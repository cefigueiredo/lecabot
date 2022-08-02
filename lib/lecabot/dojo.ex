defmodule Lecabot.Dojo do
  @moduledoc ~S"""
  Module that represents a Dojo session.
  It starts as a GenServer

    Dojo 3 atores
       - pilot : Quem vai programar na rodada
       - copilot: Quem vai auxiliar o new_pilot
       - audience: Grupo de pessoas q vai participar da sessao
                   inicialmente assistindo

     Depois de uma iteracao:
         1) Quem estava como pilot, passa a ser parte da audiencia

         2) Quem estava como copilot, passa a ser o pilot da rodada

         3) Um dos que estavam na audiencia vai ser selecionado p
             ser copilot

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
  defstruct pilot: nil, copilot: nil, audience: MapSet.new()

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

  def handle_cast(:iterate, dojo) do
    if is_nil(dojo.pilot) && is_nil(dojo.copilot) do
      [pilot, copilot] = Enum.take_random(dojo.audience, 2)

      new_audience =
        dojo.audience
        |> MapSet.delete(pilot)
        |> MapSet.delete(copilot)

      {:noreply, %__MODULE__{pilot: pilot, copilot: copilot, audience: new_audience}}
    else
      new_copilot = Enum.random(dojo.audience)

      new_audience =
        dojo.audience
        # returns audience after exclude new_copilot
        |> MapSet.delete(new_copilot)
        # Adds previous_pilot to audience and return
        |> MapSet.put(dojo.pilot)

      new_pilot = dojo.copilot

      {:noreply, %__MODULE__{pilot: new_pilot, copilot: new_copilot, audience: new_audience}}
    end
  end

  def handle_cast(_request, state) do
    {:noreply, state}
  end

  @impl GenServer
  def handle_call(:dojo, _from, dojo) do
    {:reply, dojo, dojo}
  end
end
