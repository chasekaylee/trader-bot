defmodule TraderBot.Command do
  @moduledoc """
  Module representing discord commands.
  """
  require Logger

  alias Nostrum.Api
  alias TraderBot.Command.{
    Watchlist
  }
  alias TraderBot.WatchlistServer

  @command_prefix TraderBot.get_command_prefix()

  @doc """
  Handles all of the message and sends them to the
  required command modules
  """
  def handle_message(message) do
    {command, arguments} =
      message
      |> parse_message
      |> log_command_and_args

    case command do
      "wl" ->
        case WatchlistServer.watchlist_pid(message.author.id) do
          pid when is_pid(pid)  ->
            Watchlist.execute(arguments, message)
          nil when hd(arguments) == "help"   ->
            Watchlist.execute(["help"], message)
          nil when hd(arguments) == "create" ->
            Watchlist.execute(["create"], message)
          nil ->
            Api.create_message!(message.channel_id, ~s(Watchlist not created! Create one with `#{@command_prefix}wl create`))
          end
      "bubba" ->
        Api.create_message!(message.channel_id, "lubbb")
      _ ->
        :ignore
    end
  end

########################################################################################

  defp parse_message(message) do
    message.content
      |> String.replace_prefix(@command_prefix, " ")
      |> String.trim_leading()
      |> String.downcase()
      |> String.split(" ")
      |> List.pop_at(0)
  end

  defp log_command_and_args({command, arguments}) do
    Logger.info("Command: '#{command}' Arguments: '#{Enum.join(arguments, " ")}'")
    {command, arguments}
  end
end
