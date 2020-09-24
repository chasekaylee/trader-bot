defmodule TraderBot do

  use Application

  @command_prefix Application.get_env(:trader_bot, :command_prefix, "!")

  def start(_type, _args) do

    children = [
      {Registry, keys: :unique, name: TraderBot.WatchlistRegistry},
      TraderBot.Consumer,
      TraderBot.WatchlistSupervisor
    ]

    :ets.new(:watchlist_table, [:public, :named_table])
    :ets.new(:stock_table, [:public, :named_table])

    opts = [strategy: :one_for_one, name: TraderBot.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def get_command_prefix, do: @command_prefix

  def get_id, do: Nostrum.Cache.Me.get().id
end
