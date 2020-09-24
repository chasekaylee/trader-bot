import Config

config :trader_bot,
  command_prefix: "!"

config :logger,
  level: :info,
  metadata: [:request_id]
