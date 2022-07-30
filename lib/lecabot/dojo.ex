defmodule Lecabot.Dojo do
  @moduledoc ~S"""
  Module that represents a Dojo session.
  It starts as a GenServer

  ### Examples

      iex> {:ok, dojo_pid} = GenServer.start(Lecabot.Dojo, %Lecabot.Dojo{})
      {:ok, dojo_pid}

  """
  use GenServer

  @typedoc """
  A %Lecabot.Dojo{} struct has the following attributes:
    * pilot: which stores the username for the current pilot
    * copilot: that stores the username for the current copilot
    * audience: that is a MapSet that list of unique usernames that will participate in the session
  """
  @type t :: %__MODULE__{
    pilot: String.t(),
    copilot: String.t(),
    audience: MapSet.t(String.t())
  }
  defstruct pilot: nil, copilot: nil, audience: MapSet.new

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  @impl GenServer
  def init(%__MODULE__{} = dojo) do
    {:ok, dojo}
  end

  @impl GenServer
  def handle_cast({:add_participant, participant}, dojo) do
    audience = MapSet.put(dojo.audience, participant)

    {:noreply, Map.merge(dojo, %{audience: audience})}
  end
  def handle_cast(_request, state) do
    {:noreply, state}
  end

  @impl GenServer
  def handle_call(:dojo, _from ,dojo) do
    {:reply, dojo, dojo}
  end
end
