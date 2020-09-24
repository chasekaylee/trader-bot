defmodule TraderBot.API.IexCloud do
  use Tesla

  plug Tesla.Middleware.BaseUrl, baseurl()
  plug Tesla.Middleware.Query, [token: auth()]

  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.DecodeJson

  def batch(symbols, types) do
    get("/stock/market/batch", query: [symbols: symbols, types: types, displayPercent: true])
    |> handle_response
  end

  def quote(symbol) when is_binary(symbol) do
    get("/stock/" <> symbol <> "/quote")
    |> handle_response
  end

  def quote(symbols) when is_list(symbols) do
    symbols
    |> Enum.join(",")
    |> batch("quote")
  end

  def price(symbol) when is_binary(symbol) do
    get("/stock/" <> symbol <> "/price")
    |> handle_response
  end

  def price(symbols) when is_list(symbols) do
    symbols
    |> Enum.join(",")
    |> batch("price")
  end

  ##################################################################################################

  defp auth() do
    Application.get_env(:trader_bot, :iexcloud_key)
  end

  defp baseurl() do
    Application.get_env(:trader_bot, :iexcloud_url)
  end

  defp handle_response({:ok, %Tesla.Env{status: status, headers: _headers, body: body}}) when status >= 200 and status <= 299 do
    {:ok, body}
  end

  defp handle_response({:ok, %Tesla.Env{status: status, headers: _headers, body: _body} = env}) when status >= 300 and status <= 599 do
    {:error, env}
  end

  defp handle_response({:error, reason}) do
    error = %{ message: "An error occurred while making the network request. The HTTP client returned the following reason: #{inspect(reason)}"}

    {:error, error}
  end
end
