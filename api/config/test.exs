import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :theme01, Theme01.Repo,
  username: "postgres",
  password: "postgres",
  database: "theme01_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

if System.get_env("GITHUB_ACTIONS") do
  config :theme01, Theme01.Repo,
    username: "postgres",
    password: "postgres"
end

config :bcrypt_elixir, :log_rounds, 4

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :theme01, Theme01Web.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "yZIZhWa8BJXnlX59ELRqAmNnysnfEGRclnHsmgdXmUWriDhpJQADBr29zaI/pfWa",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
