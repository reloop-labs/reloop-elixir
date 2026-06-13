defmodule Reloop.Support.Parameters do
  @moduledoc false

  @request_key_map %{
    "first_name" => "firstName",
    "last_name" => "lastName",
    "group_ids" => "groupIds",
    "group_id" => "groupId",
    "fallback_value" => "fallbackValue",
    "default_subscription" => "defaultSubscription",
    "channel_id" => "channelId",
    "property_name" => "propertyName",
    "property_type" => "propertyType",
    "contact_id" => "contactId",
    "rate_limit_enabled" => "rateLimitEnabled",
    "user_id" => "userId"
  }

  @doc """
  Pass parameters through without camelCase conversion (domain API).
  Drops nil values.
  """
  def for_snake_request(params) when is_map(params) do
    params
    |> Enum.reject(fn {_key, value} -> is_nil(value) end)
    |> Map.new()
  end

  @doc """
  Normalize request/query parameters to camelCase for contacts and API key APIs.
  """
  def for_request(params) when is_map(params) do
    params
    |> Enum.reduce(%{}, fn {key, value}, acc ->
      key = to_string(key)

      cond do
        key == "unsubscribed" and not Map.has_key?(params, :status) and not Map.has_key?(params, "status") ->
          Map.put(acc, "status", if(value, do: "unsubscribed", else: "subscribed"))

        true ->
          api_key = Map.get(@request_key_map, key, to_camel_case(key))
          Map.put(acc, api_key, normalize_value(value, :request))
      end
    end)
    |> Enum.reject(fn {_key, value} -> is_nil(value) end)
    |> Map.new()
  end

  @doc """
  Build query params for GET requests. Drops nil values.
  """
  def for_query(options) when is_map(options) do
    for_request(options)
  end

  defp normalize_value(value, :request) when is_map(value) do
    if map_size(value) == 0 do
      value
    else
      keys = Map.keys(value)

      if Enum.all?(keys, &is_integer/1) do
        Enum.map(value, fn
          {_index, item} when is_map(item) -> normalize_value(item, :request)
          {_index, item} -> item
        end)
      else
        for_request(value)
      end
    end
  end

  defp normalize_value(value, _mode), do: value

  defp to_camel_case(key) do
    if String.contains?(key, "_") do
      [first | rest] = String.split(key, "_")
      first <> Enum.map_join(rest, "", &String.capitalize/1)
    else
      key
    end
  end
end
