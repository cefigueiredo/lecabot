defmodule LecabotWeb.TwitchController do
  use LecabotWeb, :controller

  def authorize(conn, _params) do
    scopes = [
      "chat:edit",
      "chat:read",
      "whispers:edit"
    ] |> Enum.join(" ")

    authorize_parameters =
      %{
        client_id: Application.fetch_env!(:twitch, :client_id),
        redirect_uri: "http://localhost:4000/twitch/callback",
        response_type: "code",
        scope: scopes
      } |> URI.encode_query()

    redirect(conn, external: "https://id.twitch.tv/oauth2/authorize?#{authorize_parameters}")
  end

  def callback(conn, params) do
    text(conn, "tst")
  end
end
