defmodule Lecabot.Dojo do
  use GenServer

  alias Lecabot.Dojo, as: Dojo

  defstruct pilot: nil, copilot: nil, audience: []

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl GenServer
  def init(dojo = %Dojo{}) do
    {:ok, dojo}
  end

  @impl GenServer
  def handle_cast({:add_participant, participant}, dojo) do
    audience = [participant | dojo.audience]

    {:noreply, Map.merge(dojo, %{audience: audience})}
  end

  @impl GenServer
  def handle_call(:dojo, _from ,dojo) do
    {:reply, dojo, dojo}
  end
end
