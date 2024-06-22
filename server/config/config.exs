# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :ponto_cao,
  ecto_repos: [PontoCao.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :ponto_cao, PontoCaoWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: PontoCaoWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: PontoCao.PubSub,
  live_view: [signing_salt: "vNLRL+kN"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :ponto_cao, PontoCao.Mailer, adapter: Swoosh.Adapters.Local

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Config elixir to use TZ as timezone database
config :elixir, :time_zone_database, Tz.TimeZoneDatabase

# Waffle configuration, by default it will use the Local adapter but it's recommended to configure 
# a different adapter at the `config/runtime.exs`.
config :waffle,
  storage: Waffle.Storage.Local,
  # in order to have a different storage directory from url
  storage_dir_prefix: "priv/static",
  storage_dir: "images"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
