defmodule Reloop.Services.ContactChannels do
  @moduledoc false

  alias Reloop.Client
  alias Reloop.Support.Parameters

  def create(client, params) when is_map(params) do
    Client.fetch(client, :post, "/api/contacts/v1/channels/create", Parameters.for_request(params))
  end

  def list(client, params \\ %{}) do
    Client.fetch(client, :get, "/api/contacts/v1/channels/list", nil, Parameters.for_query(params))
  end

  def get(client, channel_id) do
    Client.fetch(client, :get, "/api/contacts/v1/channels/#{channel_id}")
  end

  def update(client, channel_id, params) when is_map(params) do
    Client.fetch(
      client,
      :patch,
      "/api/contacts/v1/channels/#{channel_id}",
      Parameters.for_request(params)
    )
  end

  def delete(client, channel_id) do
    Client.fetch(client, :delete, "/api/contacts/v1/channels/#{channel_id}")
  end

  def add_contact(client, channel_id, params) when is_map(params) do
    Client.fetch(client, :post, "/api/contacts/channel/#{channel_id}", Parameters.for_request(params))
  end

  def update_subscription(client, channel_id, params) when is_map(params) do
    Client.fetch(client, :patch, "/api/contacts/channel/#{channel_id}", Parameters.for_request(params))
  end
end
