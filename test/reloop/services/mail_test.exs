defmodule Reloop.Services.MailTest do
  use ExUnit.Case, async: false

  alias Reloop.Client
  alias Reloop.Services.Mail

  setup do
    bypass = Bypass.open()
    client = Client.new("rl_test", base_url: "http://127.0.0.1:#{bypass.port}")
    {:ok, bypass: bypass, client: client}
  end

  test "send posts snake_case body to /api/mail/v1/send", %{bypass: bypass, client: client} do
    Bypass.expect_once(bypass, "POST", "/api/mail/v1/send", fn conn ->
      {:ok, body, conn} = Plug.Conn.read_body(conn)

      assert Jason.decode!(body) == %{
               "from" => "Reloop <hello@send.example.com>",
               "to" => "user@example.com",
               "subject" => "Welcome to Reloop",
               "reply_to" => "support@example.com",
               "tags" => [%{"name" => "campaign", "value" => "welcome"}]
             }

      Plug.Conn.resp(
        conn,
        200,
        Jason.encode!(%{
          "success" => true,
          "messageId" => "msg_123456789",
          "status" => "sent",
          "timestamp" => "2026-01-01T00:00:00.000Z",
          "id" => "log_123456789"
        })
      )
    end)

    assert {:ok, %{"messageId" => "msg_123456789", "id" => "log_123456789"}} =
             Mail.send(client, %{
               from: "Reloop <hello@send.example.com>",
               to: "user@example.com",
               subject: "Welcome to Reloop",
               reply_to: "support@example.com",
               tags: [%{name: "campaign", value: "welcome"}]
             })
  end
end
