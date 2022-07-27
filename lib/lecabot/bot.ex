defmodule Lecabot.Bot do
  use TMI

  @impl TMI.Handler
  def handle_message(msg, sender, chat, tags) do
    IO.inspect(%{sender: sender, msg: msg, chat: chat, tags: tags})
  end

  def handle_message(msg, sender, chat) do
    IO.inspect(%{sender: sender, msg: msg, chat: chat})
  end

  def handle_join(channel, user) do
    IO.inspect("#{user} joins #{channel}")
  end

  def handle_join(channel) do
    IO.inspect "JOIN #{channel}"
  end

end
