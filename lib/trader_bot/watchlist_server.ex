defmodule TraderBot.WatchlistServer do
  @moduledoc """
  A watchlist server process that holds a `Watchlist` struct as its state.
  """

  use GenServer

  require Logger

  @timeout :timer.hours(72)

  ########## Client (Public) Interface ##########

  @doc """
  Spawns a new watchlist server process registered under the given `id`.
  """
  def start_link(id) do
    GenServer.start_link(__MODULE__,
                         {id},
                         name: via_tuple(id))
  end

  def summary(id) do
    GenServer.call(via_tuple(id), :summary)
  end

  def add(id, symbol) do
    GenServer.call(via_tuple(id), {:add, symbol})
  end

  def clear(id) do
    GenServer.cast(via_tuple(id), :clear)
  end

  def remove(id, symbol)  do
    GenServer.cast(via_tuple(id), {:remove, symbol})
  end

  @doc """
  Returns a tuple used to register and lookup a watchlist server process by id.
  """
  def via_tuple(id) do
    {:via, Registry, {TraderBot.WatchlistRegistry, id}}
  end

  @doc """
  Returns the `pid` of the watchlist server process registered under the
  given `id`, or `nil` if no process is registered.
  """
  def watchlist_pid(id) do
    id
    |> via_tuple()
    |> GenServer.whereis()
  end

  ########## Server Callbacks ##########

  def init({ id }) do

    watchlist =
      case :ets.lookup(:watchlist_table, id) do
        [] ->
          watchlist = TraderBot.Watchlist.new(id)
          :ets.insert(:watchlist_table, {id, watchlist})
          watchlist

        [{^id, watchlist}] ->
          watchlist
    end

    Logger.info("Spawned watchlist server process with id '#{id}'.")

    {:ok, watchlist, @timeout}
  end

  def handle_call({:add, symbol}, _from, watchlist) do
    new_watchlist = TraderBot.Watchlist.add(watchlist, symbol)

    :ets.insert(:watchlist_table, {my_watchlist_id(), new_watchlist})

    {:reply, summarize(new_watchlist), new_watchlist, @timeout}
  end


  def handle_call(:summary, _from, watchlist) do
    {:reply, summarize(watchlist), watchlist, @timeout}
  end

  def handle_cast(:clear, watchlist) do
    new_watchlist = TraderBot.Watchlist.clear(watchlist)

    {:noreply, new_watchlist}
  end

  def handle_cast({:remove, symbol}, watchlist) do
    new_watchlist = TraderBot.Watchlist.remove(watchlist, symbol)

    {:noreply, new_watchlist}
  end

  def handle_info(:timeout, watchlist) do
    {:stop, {:shutdown, :timeout}, watchlist}
  end

  def terminate({:shutdown, :timeout}, _watchlist) do

    Logger.info("Terminating server process named '#{my_watchlist_id}'.")

    :ets.delete(:watchlist_table, my_watchlist_id())
    :ok
  end

  def terminate(_reason, _watchlist) do
    :ok
  end

  def summarize(watchlist) do
    %{
      watching: watchlist.watching,
    }
  end

  ################################################################################


  defp my_watchlist_id do
    Registry.keys(TraderBot.WatchlistRegistry, self()) |> List.first
  end
end
