defmodule LecabotWeb.TwitchController do
  use LecabotWeb, :controller

  def authorize(conn, _params) do
    authorize_parameters =
      %{
        client_id: "",
        redirect_uri: "",
        response_type: "code",
        scope: "",
        state: ""
      } |> Phoenix.Param.to_param()

    redirect(conn, "https://id.twitch.tv/oauth2/authorize?#{authorize_parameters}")
  end

  def callback(_conn, _params) do
  end
end
