import Config

config :simple_app,
  ecto_repos: [SimpleApp.Repo],
  generators: [timestamp_type: :utc_datetime]

config :simple_app, SimpleAppWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: SimpleAppWeb.ErrorHTML, json: SimpleAppWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: SimpleApp.PubSub,
  live_view: [signing_salt: "simple_app_salt"]


config :tailwind,
  version: "3.3.0",
  simple_app: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :phoenix, :json_library, Jason

import_config "#{config_env()}.exs"