import Config

config :trader_bot,
  command_prefix: "!"

config :nostrum,
  # The number of shards you want to run your bot under, or :auto.
  num_shards: :auto

config :tesla, :adapter, Tesla.Adapter.Hackney

config :gen_tcp_accept_and_close, port: 4000
config :gen_tcp_accept_and_close, ip: {0, 0, 0, 0}

config :logger, :console, format: "$time [$level] $metadata$message\n"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
