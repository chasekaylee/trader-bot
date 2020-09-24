# defmodule TraderBot.RateLimiter do
#   def start_link, do: Genserver.start_link(__MODULE__, [])

#   def log(uid) do
#     case :ets.update_counter(:lim, uid, {2,1}, {uid,0}) do
#       # count when count > 1000 -> {:error, :limited}
#       # count -> {:ok count}
#       _ -> :ok
#     end
#   end

#   def init(_) do
#     :ets.new(:lim, [:set, :named_table, :public])
#     :timer.send_interval(60_000, :sweep)
#     {:ok, %{}}
#   end

#   def handle_info(:sweep, state) do
#     :ets.delete_all_objects(:limits)
#     {:noreply, state}
#   end
# end
