defmodule TraderBot.Consumer do
  use Nostrum.Consumer

  # alias Nostrum.Api

  @command_prefix TraderBot.get_command_prefix()

  def start_link do
    Consumer.start_link(__MODULE__, name: TraderBot.Consumer)
  end

   @doc """
  Listen to ready event and update the status.
  """
  def handle_event({:READY, _, _}) do
    Nostrum.Api.update_status("", "you type #{@command_prefix}", 3)
  end

  @doc """
  Handles the `:MESSAGE_CREATE` event. If it is
  seen as a command crated from an user, it will
  parse it to the command module.
  """
  def handle_event({:MESSAGE_CREATE, %{ author: %{ bot: bot }} = message, _ws_state}) do
    if (!bot and is_trader_bot_command? message), do:
      TraderBot.Command.handle_message(message)
  end

  @doc """
  This only exists so that when an uncaptured event is
  created the bot won't create an error!
  """
  def handle_event(_event) do
    :noop
  end

   @doc """
  Check whether a message is an TraderBot command.
  """
  defp is_trader_bot_command?(message) do
    message.content
      |> String.downcase()
      |> String.split("", trim: true)
      |> Enum.at(0)
      |> String.equivalent?(@command_prefix)
  end
end
