defmodule TraderBot.Trade do

  @enforce_keys [:user_id, :symbol, :price, :quantity]
  defstruct [:user_id, :symbol, :price, :quantity, :fee, :date]
end
