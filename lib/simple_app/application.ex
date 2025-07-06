defmodule SimpleApp.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SimpleApp.Repo,
      {DNSCluster, query: Application.get_env(:simple_app, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: SimpleApp.PubSub},
      {Finch, name: SimpleApp.Finch},
      SimpleAppWeb.Endpoint
    ]

    opts = [strategy: :one_for_one, name: SimpleApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    SimpleAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end