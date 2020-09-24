defmodule TraderBot.Watchlist do
  @enforce_keys [:id]
  defstruct [:id, :watching]

  alias __MODULE__

  @doc """
  Creates a new watchlist for the given id
  """
  def new(id) when is_integer(id) do
    %Watchlist{id: id, watching: []}
  end

  def new(id) when is_binary(id) do
    id |> String.to_integer |> new
  end

  def add(%__MODULE__{ watching: watching } = list, symbol) when is_binary(symbol) do

    watching =
      symbol
      |> String.split(",")
      |> List.flatten(watching)
      |> Enum.uniq
      |> Enum.sort(&order_asc/2)

    %{ list | watching: watching }
  end

  def remove(%__MODULE__{ watching: watching } = list, symbol) do
    watching =
      watching
      |> Enum.filter(fn item -> item != symbol end)
      |> IO.inspect
    %{ list | watching: watching}
  end

  def clear(%__MODULE__{ watching: _watching } = list) do
    Map.put(list, :watching, [])
  end

  def order_asc(s1, s2) do
    s1 <= s2
  end
end
