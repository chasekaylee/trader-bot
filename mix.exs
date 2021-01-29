defmodule TraderBot.MixProject do
  use Mix.Project

  def project do
    [
      app: :trader_bot,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :table_rex],
      mod: {TraderBot, []}
    ]
  end

  defp deps do
    [
      {:nostrum, "~> 0.4"},
      {:tesla, "~> 1.3.0"},
      {:hackney, "~> 1.16"},
      {:jason, "~> 1.2"},
      {:table_rex, "~> 3.0"},
      {:gen_tcp_accept_and_close, "~> 0.1.0"}
    ]
  end
end
