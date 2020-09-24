import Config

config :trader_bot,
  command_prefix: "!"

config :nostrum,
  num_shards: :auto # The number of shards you want to run your bot under, or :auto.

config :tesla, :adapter, Tesla.Adapter.Hackney

config :logger, :console, format: "$time [$level] $metadata$message\n"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
