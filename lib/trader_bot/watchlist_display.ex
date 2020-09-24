defmodule TraderBot.WatchlistDisplay do
  def display(watchlist) do
    print_watching(watchlist.watching)
  end

  def print_watching(watching) do
    watching
      |>Enum.map_join(", ", &(String.upcase(&1)))
  end
end