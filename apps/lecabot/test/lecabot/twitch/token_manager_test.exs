defmodule Lecabot.Twitch.TokenManagerTest do
  use ExUnit.Case

  import Mock

  doctest Lecabot.Twitch.TokenManager

  setup_all _context do
    [
      bearer_token:
        Jason.encode!(%{
          "access_token" => "token",
          "expires_in" => 120,
          "refresh_token" => "refresh",
          "scope" => [
            "channel:moderate",
            "chat:edit",
            "chat:read"
          ],
          token_type: "bearer"
        })
    ]
  end

  describe "init/1 nil" do
    test "generates token", %{bearer_token: bearer_token} do
      with_mock(HTTPoison,
        post: fn _url, <<_::binary>> ->
          {:ok,
           %HTTPoison.Response{
             status_code: 200,
             body: bearer_token
           }}
        end
      ) do
        response_token = Jason.decode!(bearer_token)

        assert Lecabot.Twitch.TokenManager.init(nil) == {:ok, response_token}
      end
    end

    test "schedules to refresh token on expiration"
  end

  describe "get_token" do
    test "retrieves the session token"
  end
end
