import Config

if System.get_env("PHX_SERVER") do
  config :simple_app, SimpleAppWeb.Endpoint, server: true
end

# Configure database for Docker in development
if System.get_env("DATABASE_URL") && config_env() == :dev do
  config :simple_app, SimpleApp.Repo,
    url: System.get_env("DATABASE_URL"),
    pool_size: 10,
    show_sensitive_data_on_connection_error: true
end

# Configure endpoint for Docker in development
if System.get_env("PHX_SERVER") && config_env() == :dev do
  config :simple_app, SimpleAppWeb.Endpoint,
    http: [ip: {0, 0, 0, 0}, port: 80],
    secret_key_base: System.get_env("SECRET_KEY_BASE") || "dev-secret-key-base-that-is-at-least-64-bytes-long-for-development-use-only"
end

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  maybe_ipv6 = if System.get_env("ECTO_IPV6") in ~w(true 1), do: [:inet6], else: []

  config :simple_app, SimpleApp.Repo,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    socket_options: maybe_ipv6

  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  host = System.get_env("PHX_HOST") || "example.com"
  port = String.to_integer(System.get_env("PORT") || "4000")

  config :simple_app, SimpleAppWeb.Endpoint,
    url: [host: host, port: 443, scheme: "https"],
    http: [
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: port
    ],
    secret_key_base: secret_key_base
end