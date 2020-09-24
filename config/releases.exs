import Config

config :trader_bot,
    iexcloud_url: System.fetch_env!("IEXCLOUD_URL"),
    iexcloud_key: System.fetch_env!("IEXCLOUD_KEY")

config :nostrum,
    token: System.fetch_env!("DISCORD_BOT_TOKEN")
