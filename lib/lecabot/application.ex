defmodule Lecabot.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    [bot_config] = Application.fetch_env!(:lecabot, :bots)

    children = [
      # Starts a worker by calling: Lecabot.Worker.start_link(arg)
      # {Lecabot.Worker, arg}
      {TMI.Supervisor, bot_config},
      {Lecabot.Dojo, %Lecabot.Dojo{}}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Lecabot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
