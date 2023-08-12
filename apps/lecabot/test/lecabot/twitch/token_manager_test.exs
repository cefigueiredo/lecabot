defmodule Lecabot.Twitch.TokenManagerTest do
  use ExUnit.Case

  import Mock

  doctest Lecabot.Twitch.TokenManager

  setup _context do
    bearer_token = %{
      "access_token" => "token",
      "expires_in" => 120,
      "refresh_token" => "refresh",
      "scope" => [
        "channel:moderate",
        "chat:edit",
        "chat:read"
      ],
      token_type: "bearer"
    }

    [
      bearer_token: bearer_token,
      mocked_ok_post: fn _url, _client_token ->
        {:ok,
         %HTTPoison.Response{
           status_code: 200,
           # json string as response for the oauth request
           body: Jason.encode!(bearer_token)
         }}
      end
    ]
  end

  # setup_with_mocks([
  #   {HTTPoison, {}, [post: quote(do: context.mocked_ok_post)]},
  #   quote(do: Process.send_after())
  # ], context, )

  describe "init/1 nil" do
    test "generates token", %{bearer_token: bearer_token, mocked_ok_post: ok_post} do
      with_mock(HTTPoison, post: ok_post) do
        response_token = bearer_token

        assert Lecabot.Twitch.TokenManager.init(nil) == {:ok, response_token}
      end
    end

    test "schedules to refresh token on expiration", %{
      bearer_token: bearer_token,
      mocked_ok_post: ok_post
    } do
      with_mock(HTTPoison, post: ok_post) do
      end
    end
  end

  describe "get_token" do
    test "retrieves the session token"
  end
end
