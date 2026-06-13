defmodule Reloop.Support.ParametersTest do
  use ExUnit.Case, async: true

  alias Reloop.Support.Parameters

  test "for_snake_request keeps snake_case atom keys" do
    assert Parameters.for_snake_request(%{
             domain: "send.example.com",
             click_tracking: true,
             custom_return_path: "inbound",
             ignored: nil
           }) == %{
             domain: "send.example.com",
             click_tracking: true,
             custom_return_path: "inbound"
           }
  end

  test "for_snake_request keeps snake_case string keys" do
    assert Parameters.for_snake_request(%{
             "domain" => "send.example.com",
             "click_tracking" => true,
             "ignored" => nil
           }) == %{
             "domain" => "send.example.com",
             "click_tracking" => true
           }
  end

  test "for_query drops nil values" do
    assert Parameters.for_query(%{page: 2, limit: 5, status: "active", q: nil}) == %{
             "page" => 2,
             "limit" => 5,
             "status" => "active"
           }
  end

  test "for_request converts snake_case keys to camelCase" do
    assert Parameters.for_request(%{first_name: "Ada", group_id: "grp_1"}) == %{
             "firstName" => "Ada",
             "groupId" => "grp_1"
           }
  end

  test "for_snake_request encodes to snake_case json" do
    json =
      %{domain: "send.example.com", click_tracking: true, custom_return_path: "inbound"}
      |> Parameters.for_snake_request()
      |> Jason.encode!()

    assert json =~ "\"click_tracking\":true"
    assert json =~ "\"custom_return_path\":\"inbound\""
    refute json =~ "clickTracking"
  end
end
