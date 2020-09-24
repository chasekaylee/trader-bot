defmodule TraderBot.Command.Watchlist do

  alias Nostrum.Api
  alias Nostrum.Struct.Embed

  @command_prefix TraderBot.get_command_prefix()
  @summary_table_headers [
    "Symbol",
    "Price",
    "Change",
    "Change (%)",
    "High",
    "Low",
    "Volume",
    "Avg. Volume",
    "Latest Update",
  ]
  @price_table_headers ["Symbol", "Price"]

  def execute(["help"], %{channel_id: channel_id, author: %{id: _id }}) do
    embed =
      %Nostrum.Struct.Embed{}
      |> Embed.put_title("Help for #{@command_prefix}wl command")
      |> Embed.put_field("```#{@command_prefix}wl create```", "Creates your watchlist. This needs to be done before any other commands.")
      |> Embed.put_field("```#{@command_prefix}wl add <symbol>```", "Adds a symbol to your watchlist. Can be added by individual symbol or a comma seperated list (no spaces). \n\n Example: ```#{@command_prefix}wl add MSFT``` or ```#{@command_prefix}wl add MSFT,APPL,TSLA```")
      |> Embed.put_field("```#{@command_prefix}wl current```", "Shows the current symbols in your watchlist.")
      |> Embed.put_field("```#{@command_prefix}wl clear```", "Clears your watchlist.")
      |> Embed.put_field("```#{@command_prefix}wl summary```", "Shows an high level summary of each symbol in your watchlist.")
      |> Embed.put_field("```#{@command_prefix}wl prices```", "Shows the prices for each symbol in your watchlist.")
      |> Embed.put_field("```#{@command_prefix}wl remove <symbol>```", "Removes a symbol from your watchlist (only one at a time).")
      # In case decide to pay for IEXcloud account
      |> Embed.put_url("https://buymeacoff.ee/chasekaylee")

    Api.create_message!(channel_id, embed: embed)
  end

  def execute(["add", symbol], %{channel_id: channel_id, author: %{id: id }}) do
    watchlist =
      TraderBot.WatchlistServer.add(id, symbol)
      |> TraderBot.WatchlistDisplay.display

    Api.create_message!(channel_id, "Added #{String.upcase(symbol)} to watchlist. Current watchlist: #{watchlist}")
  end

  def execute(["create"], %{channel_id: channel_id, author: %{id: id, username: username }}) do
    TraderBot.WatchlistSupervisor.create_watchlist(id)

    Api.create_message!(channel_id, "Created watchlist for #{username}.")
  end

  def execute(["current"], %{channel_id: channel_id, author: %{id: id }}) do
    watchlist =
      TraderBot.WatchlistServer.summary(id)
      |> TraderBot.WatchlistDisplay.display

      case watchlist do
        "" -> Api.create_message!(channel_id, "Your watchlist is empty.")
        _ -> Api.create_message!(channel_id, "Current watchlist: #{watchlist}")
        end
  end

  def execute(["clear"], %{channel_id: channel_id, author: %{id: id }}) do
    TraderBot.WatchlistServer.clear(id)
    Api.create_message!(channel_id, "Your watchlist has been cleared.")
  end

  def execute(["summary"], %{channel_id: channel_id, author: %{id: id }}) do
    %{watching: watching} = TraderBot.WatchlistServer.summary(id)

    case Kernel.length(watching) do
      len when len > 0 ->
        { :ok, response } = TraderBot.API.IexCloud.quote(watching)

        quotes =
          response
            |> Enum.map(fn({ _symbol, quote }) -> unwrap(quote) end)
            |> Enum.map(fn quote ->
              [
                quote.symbol,
                quote.latest_price,
                quote.change,
                quote.change_percent,
                quote.high,
                quote.low,
                quote.latest_volume,
                quote.avg_total_volume,
                quote.latest_time,
              ]
            end)
            |> TableRex.quick_render!(@summary_table_headers)

        Api.create_message!(channel_id, ~s(```#{quotes}```))
      0 ->
        Api.create_message!(channel_id, "You are not watching any stonks.")
    end
  end

  def execute(["prices"], %{channel_id: channel_id, author: %{id: id }}) do
    %{watching: watching} = TraderBot.WatchlistServer.summary(id)

    case Kernel.length(watching) do
      len when len > 0 ->
        { :ok, response } = TraderBot.API.IexCloud.price(watching)

        prices =
          response
          |> Enum.map(fn { symbol, price } -> [symbol, Map.get(price, "price")] end)
          |> TableRex.quick_render!(@price_table_headers)

        Api.create_message!(channel_id, ~s(```#{prices}```))
      0 ->
        Api.create_message!(channel_id, "You are not watching any stonks.")
    end

  end

  def execute(["remove", symbol], %{channel_id: channel_id, author: %{id: id }}) do
    TraderBot.WatchlistServer.remove(id, symbol)
    Api.create_message!(channel_id, "#{symbol} has been removed from your watchlist")
  end

  def execute(_, %{channel_id: channel_id, author: %{id: _id }}) do
    Api.create_message!(channel_id, "Please provide valid arguments.")
  end

  ############################################################################################################

  defp unwrap(%{"quote" => quote }) do
    %TraderBot.Quote{
      symbol: Map.get(quote, "symbol"),
      change: Map.get(quote, "change"),
      change_percent: Map.get(quote, "changePercent"),
      extended_price: Map.get(quote, "extendedPrice"),
      extended_change: Map.get(quote, "extendedChange"),
      extended_change_percent: Map.get(quote, "extendedChangePercent"),
      latest_time: Map.get(quote, "latestTime"),
      latest_price: Map.get(quote, "latestPrice"),
      latest_volume: Map.get(quote, "latestVolume"),
      latest_source: Map.get(quote, "latestSource"),
      avg_total_volume: Map.get(quote, "avgTotalVolume"),
      market_cap: Map.get(quote, "marketCap"),
      iex_bid_price: Map.get(quote, "iexBidPrice"),
      iex_bid_size: Map.get(quote, "iexBidSize"),
      iex_ask_price: Map.get(quote, "iexAskPrice"),
      iex_ask_size: Map.get(quote, "iexAskSize"),
      open: Map.get(quote, "open"),
      close: Map.get(quote, "close"),
      high: Map.get(quote, "high"),
      low: Map.get(quote, "low"),
    }
  end
end

# @summary_table_headers [
#   "Symbol",
#   "Price",
#   "Change",
#   "Change (%)",
  # "Open",
  # "Close",
  # "High",
  # "Low",
  # "Volume",
  # "Avg. Volume",
  # "Latest Update",
  # "AH Price",
  # "AH Change",
  # "AH Change (%)",
  # "Latest Source",
  # "Market Cap",
  # "IEX Bid Price",
  # "IEX Bid Size",
  # "IEX Ask Price",
  # "IEX Ask Size",
# ]

# [
#   quote.symbol,
#   quote.latest_price,
#   quote.change,
#   quote.change_percent,
#   # quote.open,
#   # quote.close,
#   quote.high,
#   quote.low,
#   quote.latest_volume,
#   quote.avg_total_volume,
#   quote.latest_time,
  # quote.extended_price,
  # quote.extended_change,
  # quote.extended_change_percent,
  # quote.latest_source,
  # quote.market_cap,
  # quote.iex_bid_price,
  # quote.iex_bid_size,
  # quote.iex_ask_price,
  # quote.iex_ask_size,
# ]
