defmodule Lecabot.Bot do
  use TMI

  alias Lecabot.Dojo

  @impl TMI.Handler
  def handle_message(msg, sender, chat, tags) do
    IO.inspect(%{sender: sender, msg: msg, chat: chat, tags: tags})
  end

  def handle_message("!participar", sender, _chat) do
    add_participant(sender)
  end

  def handle_message("!participantes", _sender, _chat) do
    case DynamicSupervisor.count_children(Lecabot.DojoSupervisor) do
      %{active: 0} ->
        {:ignore, "None dojo session running."}

      _ ->
        %Dojo{audience: audience} = GenServer.call(Dojo, :dojo)

        participantes =
          audience
          |> Enum.join(", ")

        say("lecaduco", "Os participantes do Dojo serão: #{participantes}")
    end
  end

  def handle_message("!createdojo", "lecaduco", _chat) do
    child_spec = Supervisor.child_spec({Dojo, %Dojo{}}, id: Lecabot.Dojo)

    case DynamicSupervisor.start_child(Lecabot.DojoSupervisor, child_spec) do
      {:error, {:already_started, _}} ->
        {:ignore, "Dojo session is already running"}

      _ ->
        {:ok, "Dojo started successfuly."}
    end
  end

  def handle_message("!closedojo", "lecaduco", _channel) do
    case DynamicSupervisor.terminate_child(Lecabot.DojoSupervisor, Lecabot.Dojo) do
      :ok ->
        say("lecaduco", "Dojo terminado!")

      _ ->
        {:ignore, "None dojo session running"}
    end
  end

  def handle_message("!iterate", "lecaduco", _channel) do
    case DynamicSupervisor.count_children(Lecabot.DojoSupervisor) do
      %{active: 0} ->
        {:ignore, "None dojo session running."}

      _ ->
        GenServer.cast(Dojo, :iterate)
        %Dojo{pilot: pilot, copilot: copilot} = GenServer.call(Dojo, :dojo)

        if pilot do
          say("lecaduco", "Jogares da rodada:\n --> PILOTO: #{pilot} \n --> COPILOTO: #{copilot}")
        else
          say("lecaduco", "A rodada nao pode iniciar, faltam jogadores.")
        end
    end
  end

  def handle_message(msg, "lecaduco", _chat) do
    IO.puts("Eu disse: #{msg}")
  end

  def handle_message(msg, sender, _chat) do
    cond do
      msg =~ ~r/.*!participar.*/ ->
        add_participant(sender)

      msg == "!createdojo" ->
        {:ignore, "\"#{sender}\" is not allowed to create dojos."}

      true ->
        IO.puts("#{sender} disse: #{msg}") # return is :ok
    end
  end

  def handle_join(channel, user) do
    IO.inspect("#{user} joins #{channel}")
  end

  defp add_participant(sender) do
    case DynamicSupervisor.count_children(Lecabot.DojoSupervisor) do
      %{active: 0} ->
        {:ignore, "None dojo session running"}

      _ ->
        IO.puts("#{sender} vai participar!")
        GenServer.cast(Dojo, {:add_participant, sender})
    end
  end
end
