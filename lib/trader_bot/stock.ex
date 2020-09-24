defmodule TraderBot.Stock do

  @enforce_keys [:symbol, :price]
  defstruct [:symbol, :price]

  alias __MODULE__

  @doc """
  Creates a stock with the given `symbol` and `price`.
  """
  def new(symbol, price) do
    %Stock{symbol: symbol, price: price}
  end
end
