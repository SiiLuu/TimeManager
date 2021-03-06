# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :theme01,
  ecto_repos: [Theme01.Repo]

# Configures the endpoint
config :theme01, Theme01Web.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: Theme01Web.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Theme01.PubSub,
  live_view: [signing_salt: "R6mkVzkT"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.12.18",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2016 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"

config :theme01, Theme01.Guardian,
  issuer: "theme01",
  secret_key: "dxMUlbSJawF81OdQFrVtTulp0TOG6CQiSwcGSxR42GtjcRD3RDDLajx9PczHQO9r"
