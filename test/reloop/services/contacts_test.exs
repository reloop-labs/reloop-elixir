defmodule Reloop.Services.ContactsTest do
  use ExUnit.Case, async: true

  alias Reloop.Client
  alias Reloop.Services.Contacts

  setup do
    bypass = Bypass.open()
    client = Client.new("rl_test", base_url: "http://127.0.0.1:#{bypass.port}")
    {:ok, bypass: bypass, client: client}
  end

  test "create posts to /api/contacts/create with camelCase body", %{bypass: bypass, client: client} do
    Bypass.expect_once(bypass, "POST", "/api/contacts/create", fn conn ->
      {:ok, body, conn} = Plug.Conn.read_body(conn)
      assert Jason.decode!(body) == %{"email" => "user@example.com", "firstName" => "Ada"}
      Plug.Conn.resp(conn, 200, Jason.encode!(%{"id" => "con_1"}))
    end)

    assert {:ok, %{"id" => "con_1"}} =
             Contacts.create(client, %{email: "user@example.com", first_name: "Ada"})
  end

  test "get uses retrieve route", %{bypass: bypass, client: client} do
    Bypass.expect_once(bypass, "GET", "/api/contacts/retrieve/con_1", fn conn ->
      Plug.Conn.resp(conn, 200, Jason.encode!(%{"id" => "con_1"}))
    end)

    assert {:ok, %{"id" => "con_1"}} = Contacts.get(client, "con_1")
  end

  test "list with group_id uses group contacts route", %{bypass: bypass, client: client} do
    Bypass.expect_once(bypass, "GET", "/api/contacts/v1/groups/grp_1/contacts", fn conn ->
      assert conn.query_string == "page=1"
      Plug.Conn.resp(conn, 200, Jason.encode!(%{"contacts" => []}))
    end)

    assert {:ok, %{"contacts" => []}} = Contacts.list(client, %{group_id: "grp_1", page: 1})
  end

  test "add_channel_contact uses channel route", %{bypass: bypass, client: client} do
    Bypass.expect_once(bypass, "POST", "/api/contacts/channel/ch_1", fn conn ->
      {:ok, body, conn} = Plug.Conn.read_body(conn)
      assert Jason.decode!(body) == %{"contactId" => "con_1"}
      Plug.Conn.resp(conn, 200, Jason.encode!(%{"id" => "ch_1"}))
    end)

    assert {:ok, %{"id" => "ch_1"}} =
             Contacts.add_channel_contact(client, "ch_1", %{contact_id: "con_1"})
  end
end
