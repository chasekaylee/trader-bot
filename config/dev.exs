import Config

config :trader_bot,
  command_prefix: "!"

config :logger, :console, format: "$time [$level] $metadata$message\n"
