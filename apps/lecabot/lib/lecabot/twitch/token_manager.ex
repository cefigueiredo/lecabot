defmodule Lecabot.Twitch.TokenManager do
  use GenServer

  @impl true
  def init(nil) do
    {:ok, generate_token()}
  end

  defp generate_token() do
    url = Application.fetch_env!(:lecabot, Lecabot.Twitch)[:oauth_url]

    headers = [
      {"Content-Type", "application/x-www-form-urlencoded"},
      {"Accept", "application/json"}
    ]

    req_body =
      Application.fetch_env!(:lecabot, Lecabot.Twitch)
      |> Keyword.take([:client_id, :client_secret, :code, :grant_type, :redirect_uri])
      |> URI.encode_query(:www_form)

    {:ok, %HTTPoison.Response{body: res_body}} = HTTPoison.post(url, req_body, headers)

    Poison.decode!(res_body)
  end
end
