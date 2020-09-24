defmodule TraderBotTest do
  use ExUnit.Case
  doctest TraderBot

  test "greets the world" do
    assert TraderBot.hello() == :world
  end
end
