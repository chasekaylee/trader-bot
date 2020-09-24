defmodule TraderBot.WatchlistSupervisor do
   @moduledoc """
  A supervisor that starts `WatchlistServer` processes dynamically.
  """

  use DynamicSupervisor

  alias TraderBot.WatchlistServer

  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  @doc """
  Creates a `WatchlistServer` process and supervises it.
  """
  def create_watchlist(id) do
    child_spec = %{
      id: WatchlistServer,
      start: {WatchlistServer, :start_link, [id]},
      restart: :transient
    }

    DynamicSupervisor.start_child(__MODULE__, child_spec)
  end

  @doc """
  Terminates the `WatchlistServer` process normally. It won't be restarted.
  """
  def delete_watchlist(id) do
    :ets.delete(:watchlist_table, id)

    child_pid = WatchlistServer.watchlist_pid(id)
    DynamicSupervisor.terminate_child(__MODULE__, child_pid)
  end
end
