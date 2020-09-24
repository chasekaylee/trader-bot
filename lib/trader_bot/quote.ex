defmodule TraderBot.Quote do
  @derive Jason.Encoder
  defstruct [
    # string	Refers to the stock ticker.
    :symbol,
    # number	Refers to the change in price between latestPrice and previousClose
    :change,
    # number	Refers to the percent change in price between latestPrice and previousClose. For example, a 5% change would be represented as 0.05. You can use the query string parameter displayPercent to return this field multiplied by 100. So, 5% change would be represented as 5.
    :change_percent,
    # number	Refers to the 15 minute delayed price outside normal market hours 0400 - 0930 ET and 1600 - 2000 ET. This provides pre market and post market price. This is purposefully separate from latestPrice so users can display the two prices separately.
    :extended_price,
    # extendedChange	number	Refers to the price change between extendedPrice and latestPrice.
    :extended_change,
    # number	Refers to the price change percent between extendedPrice and latestPrice.
    :extended_change_percent,
    # string	Refers to a human readable time/date of when latestPrice was last updated. The format will vary based on latestSource is inteded to be displayed to a user. Use latestUpdate for machine readable timestamp.
    :latest_time,
    # number	Use this to get the latest price
    # Refers to the latest relevant price of the security which is derived from multiple sources. We first look for an IEX real time price. If an IEX real time price is older than 15 minutes, 15 minute delayed market price is used. If a 15 minute delayed price is not available, we will use the current day close price. If a current day close price is not available, we will use the last available closing price (listed below as previousClose)
    # IEX real time price represents trades on IEX only. Trades occur across over a dozen exchanges, so the last IEX price can be used to indicate the overall market price.
    # 15 minute delayed prices are from all markets using the Consolidated Tape.
    # This will not included pre or post market prices.
    :latest_price,
    # number	Use this to get the latest volume
    # Refers to the latest total market volume of the stock across all markets. This will be the most recent volume of the stock during trading hours, or it will be the total volume of the last available trading day.
    :latest_volume,
    # string	This will represent a human readable description of the source of latestPrice.
    # Possible values are "IEX real time price", "15 minute delayed price", "Close" or "Previous close"
    :latest_source,
    # number	Refers to the 30 day average volume.
    :avg_total_volume,
    # number	is calculated in real time using latestPrice.
    :market_cap,
    # number	Refers to the best bid price on IEX.
    :iex_bid_price,
    # number	Refers to amount of shares on the bid on IEX.
    :iex_bid_size,
    # number	Refers to the best ask price on IEX.
    :iex_ask_price,
    # number	Refers to amount of shares on the ask on IEX.
    :iex_ask_size,
    # number	Refers to the official open price from the SIP. 15 minute delayed (can be null after 00:00 ET, before 9:45 and weekends)
    :open,
    # number	Refers to the official close price from the SIP. 15 minute delayed
    :close,
    # number	Refers to the market-wide highest price from the SIP. 15 minute delayed during normal market hours 9:30 - 16:00 (null before 9:45 and weekends).
    :high,
    # number	Refers to the market-wide lowest price from the SIP. 15 minute delayed during normal market hours 9:30 - 16:00 (null before 9:45 and weekends).
    :low,
  ]
end