# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :user,
  ecto_repos: [User.Repo]

# Configures the endpoint
config :user, UserWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "SAXrt/E3Bnols8qmbBv701rK6g58+EnJ4YyGKcOt2Fc2GZ+PESpUxErxXo+WbCjn",
  render_errors: [view: UserWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: User.PubSub,
  live_view: [signing_salt: "ygbxmHxk"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
