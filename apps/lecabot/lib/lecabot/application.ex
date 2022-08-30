defmodule Lecabot.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    # bot_config = Lecabot.Twitch.TMIConfig.generate

    children = [
      # Start the Ecto repository
      Lecabot.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Lecabot.PubSub},
      # Start a worker by calling: Lecabot.Worker.start_link(arg)
      # {Lecabot.Worker, arg}
      # {TMI.Supervisor, bot_config},
      {DynamicSupervisor, name: Lecabot.DojoSupervisor, strategy: :one_for_one}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Lecabot.Supervisor)
  end
end
