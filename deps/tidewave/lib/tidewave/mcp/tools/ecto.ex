defmodule Tidewave.MCP.Tools.Ecto do
  @moduledoc false

  alias Tidewave.MCP.Tools.Source

  def tools do
    if repos_configured?() do
      repos =
        Enum.map(ecto_repos(), fn repo ->
          %{repo: inspect(repo), adapter: inspect(repo.__adapter__())}
        end)

      default_repo = List.first(repos)

      [
        %{
          name: "execute_sql_query",
          description: """
          Executes the given SQL query against the given default or specified Ecto repository.
          Returns the result as an Elixir data structure.

          Note that the output is limited to 50 rows at a time. If you need to see more, perform additional calls
          using LIMIT and OFFSET in the query. If you know that only specific columns are relevant,
          only include those in the SELECT clause.

          You can use this tool to select user data, manipulating entries, and introspect the application data domain.
          Always ensure to use the correct SQL commands for the database you are using. The description of the
          repo parameter includes a list of available repositories and their adapters.
          """,
          inputSchema: %{
            type: "object",
            required: ["query"],
            properties: %{
              repo: %{
                type: "string",
                description: """
                The module name of the Ecto repository to use.

                The available repositories are:

                #{Jason.encode!(repos, pretty: true)}

                If no repository is specified, the first repository is used:
                #{Jason.encode!(default_repo, pretty: true)}
                """
              },
              query: %{
                type: "string",
                description: """
                The SQL query to execute. Parameters can be passed using the appropriate database syntax,
                such as $1, $2, for PostgreSQL, ? for MySQL, and so on.
                """
              },
              arguments: %{
                type: "array",
                description:
                  "The arguments to pass to the query. The query must contain corresponding parameters.",
                items: %{}
              }
            }
          },
          callback: &execute_sql_query/2
        },
        %{
          name: "get_ecto_schemas",
          description: """
          Lists all Ecto schema modules and their file path in the current project.

          Use this tool to get an overview of available schemas if the project uses Ecto.
          You should prefer this tool over grepping the file system when you need to find a specific schema.
          """,
          inputSchema: %{
            type: "object",
            required: [],
            properties: %{}
          },
          callback: &get_ecto_schemas/1
        }
      ]
    else
      []
    end
  end

  def execute_sql_query(%{"query" => query} = args, assigns) do
    repo =
      case args["repo"] do
        nil -> List.first(ecto_repos())
        repo -> Module.concat([repo])
      end

    limit = Keyword.get(assigns.inspect_opts, :limit, 50)

    case repo.query(query, args["arguments"] || []) do
      {:ok, result} ->
        preamble =
          case result do
            %{num_rows: num_rows} when num_rows > limit ->
              "Query returned #{num_rows} rows. Only the first #{limit} rows are included in the result. Use LIMIT + OFFSET in your query to show more rows if applicable.\n\n"

            _ ->
              ""
          end

        {:ok, preamble <> inspect(result, assigns.inspect_opts)}

      {:error, reason} ->
        {:error, "Failed to execute query: #{inspect(reason, assigns.inspect_opts)}"}
    end
  end

  def execute_sql_query(_) do
    {:error, :invalid_arguments}
  end

  def get_ecto_schemas(_args) do
    schemas =
      for module <- project_modules(),
          Code.ensure_loaded?(module),
          function_exported?(module, :__changeset__, 0) do
        case Source.get_source_location(%{"reference" => inspect(module)}) do
          {:ok, source_file} ->
            %{module: inspect(module), source_file: source_file}

          _ ->
            %{module: inspect(module), source_file: nil}
        end
      end

    case schemas do
      [] -> {:error, "No Ecto schemas found in the project"}
      schemas -> {:ok, Jason.encode!(schemas)}
    end
  end

  defp ecto_repos do
    # this is the same code ecto uses to find repos for tasks like mix ecto.migrate
    # https://github.com/elixir-ecto/ecto/blob/cd0f70b4cdd949767ea7cbe7d635e70917384b38/lib/mix/ecto.ex#L24-L52
    apps =
      if apps_paths = Mix.Project.apps_paths() do
        Enum.filter(Mix.Project.deps_apps(), &is_map_key(apps_paths, &1))
      else
        [Mix.Project.config()[:app]]
      end

    apps
    |> Enum.flat_map(fn app ->
      Application.load(app)
      Application.get_env(app, :ecto_repos, [])
    end)
    |> Enum.uniq()
    |> case do
      [] ->
        []

      repos ->
        repos
    end
  end

  defp repos_configured? do
    ecto_repos() != []
  end

  defp project_modules do
    files =
      Mix.Project.compile_path()
      |> File.ls!()
      |> Enum.sort()

    for file <- files, [basename, ""] <- [:binary.split(file, ".beam")] do
      String.to_atom(basename)
    end
  end
end
