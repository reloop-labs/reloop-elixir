defmodule Reloop.Services.DomainTest do
  use ExUnit.Case, async: false

  alias Reloop.Client
  alias Reloop.Services.Domain

  setup do
    bypass = Bypass.open()
    client = Client.new("rl_test", base_url: "http://127.0.0.1:#{bypass.port}")
    {:ok, bypass: bypass, client: client}
  end

  test "create posts snake_case body to /api/domain/v1/create", %{bypass: bypass, client: client} do
    Bypass.expect_once(bypass, "POST", "/api/domain/v1/create", fn conn ->
      {:ok, body, conn} = Plug.Conn.read_body(conn)
      assert Jason.decode!(body) == %{
               "domain" => "send.example.com",
               "click_tracking" => true,
               "custom_return_path" => "inbound"
             }

      Plug.Conn.resp(
        conn,
        200,
        Jason.encode!(%{
          "object" => "domain",
          "id" => "dom_1",
          "domain" => "send.example.com",
          "status" => "pending"
        })
      )
    end)

    assert {:ok, %{"id" => "dom_1"}} =
             Domain.create(client, %{
               domain: "send.example.com",
               click_tracking: true,
               custom_return_path: "inbound",
               ignored: nil
             })
  end

  test "list builds query params on /api/domain/v1/list", %{bypass: bypass, client: client} do
    Bypass.expect_once(bypass, "GET", "/api/domain/v1/list", fn conn ->
      assert conn.query_string == "page=2&limit=5&status=active&q=example"

      Plug.Conn.resp(
        conn,
        200,
        Jason.encode!(%{
          "object" => "domain",
          "domains" => [],
          "total" => 0,
          "page" => 2,
          "limit" => 5,
          "event" => "evt_1"
        })
      )
    end)

    assert {:ok, %{"total" => 0}} =
             Domain.list(client, %{
               page: 2,
               limit: 5,
               status: "active",
               q: "example"
             })
  end

  test "get_nameservers uses /api/domain/v1/nameservers/:id", %{bypass: bypass, client: client} do
    Bypass.expect_once(bypass, "GET", "/api/domain/v1/nameservers/dom_1", fn conn ->
      Plug.Conn.resp(
        conn,
        200,
        Jason.encode!(%{
          "object" => "domain_nameservers",
          "domainId" => "dom_1",
          "dnsProvider" => "cloudflare",
          "nameservers" => ["ns1.example.net"]
        })
      )
    end)

    assert {:ok, %{"dnsProvider" => "cloudflare"}} = Domain.get_nameservers(client, "dom_1")
  end

  test "verify posts to /api/domain/v1/verify/:id", %{bypass: bypass, client: client} do
    Bypass.expect_once(bypass, "POST", "/api/domain/v1/verify/dom_1", fn conn ->
      Plug.Conn.resp(
        conn,
        200,
        Jason.encode!(%{"object" => "domain_status", "status" => "active"})
      )
    end)

    assert {:ok, %{"status" => "active"}} = Domain.verify(client, "dom_1")
  end

  test "forward_dns posts email to forward-dns route", %{bypass: bypass, client: client} do
    Bypass.expect_once(bypass, "POST", "/api/domain/v1/verify/dom_1/forward-dns", fn conn ->
      {:ok, body, conn} = Plug.Conn.read_body(conn)
      assert Jason.decode!(body) == %{"email" => "admin@example.com"}

      Plug.Conn.resp(conn, 200, Jason.encode!(%{"success" => true}))
    end)

    assert {:ok, %{"success" => true}} =
             Domain.forward_dns(client, "dom_1", %{email: "admin@example.com"})
  end

  test "get, update, and delete use /api/domain/v1/:id routes", %{bypass: bypass, client: client} do
    Bypass.expect(bypass, fn conn ->
      case {conn.method, conn.request_path} do
        {"GET", "/api/domain/v1/dom_1"} ->
          Plug.Conn.resp(conn, 200, Jason.encode!(%{"id" => "dom_1", "domain" => "send.example.com"}))

        {"PATCH", "/api/domain/v1/dom_1"} ->
          {:ok, body, conn} = Plug.Conn.read_body(conn)
          assert Jason.decode!(body) == %{"click_tracking" => false}
          Plug.Conn.resp(conn, 200, Jason.encode!(%{"id" => "dom_1", "isClickTrackingEnabled" => false}))

        {"DELETE", "/api/domain/v1/dom_1"} ->
          Plug.Conn.resp(conn, 200, Jason.encode!(%{"id" => "dom_1", "deleted" => true}))

        _ ->
          Plug.Conn.resp(conn, 404, "not found")
      end
    end)

    assert {:ok, %{"domain" => "send.example.com"}} = Domain.get(client, "dom_1")

    assert {:ok, %{"isClickTrackingEnabled" => false}} =
             Domain.update(client, "dom_1", %{click_tracking: false})

    assert {:ok, %{"deleted" => true}} = Domain.delete(client, "dom_1")
  end
end
