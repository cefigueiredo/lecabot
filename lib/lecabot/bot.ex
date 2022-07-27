defmodule Lecabot.Bot do
  use TMI

  @impl TMI.Handler
  def handle_message(msg, sender, chat, tags) do
    IO.inspect(%{sender: sender, msg: msg, chat: chat, tags: tags})
  end

  def handle_message(msg, sender, chat) do
    case sender do
      "lecaduco" ->
        IO.puts "Eu disse: #{msg}"
      origem ->
        IO.puts "#{origem} disse: #{msg}"
    end
  end

  def handle_join(channel, user) do
    IO.inspect("#{user} joins #{channel}")
  end
end
