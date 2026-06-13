defmodule Reloop.Services.Contacts do
  @moduledoc """
  Manage contacts, properties, groups, and channels.
  """

  alias Reloop.Client
  alias Reloop.Services.ContactChannels
  alias Reloop.Services.ContactGroups
  alias Reloop.Support.Parameters

  def create(client, params) when is_map(params) do
    Client.fetch(client, :post, "/api/contacts/create", Parameters.for_request(params))
  end

  def get(client, contact_id) do
    Client.fetch(client, :get, "/api/contacts/retrieve/#{contact_id}")
  end

  def list(client, params \\ %{}) do
    query = Parameters.for_query(params)
    group_id = Map.get(query, "groupId") || Map.get(query, "group_id")

    if group_id do
      filtered =
        query
        |> Map.drop(["groupId", "group_id"])

      ContactGroups.list_contacts(client, group_id, filtered)
    else
      Client.fetch(client, :get, "/api/contacts/list", nil, query)
    end
  end

  def update(client, contact_id, params) when is_map(params) do
    Client.fetch(client, :patch, "/api/contacts/#{contact_id}", Parameters.for_request(params))
  end

  def delete(client, contact_id) do
    Client.fetch(client, :delete, "/api/contacts/#{contact_id}")
  end

  def create_property(client, params) when is_map(params) do
    Client.fetch(
      client,
      :post,
      "/api/contacts/v1/properties/create",
      Parameters.for_request(params)
    )
  end

  def list_properties(client, params \\ %{}) do
    Client.fetch(
      client,
      :get,
      "/api/contacts/v1/properties/list",
      nil,
      Parameters.for_query(params)
    )
  end

  def update_property(client, contact_property_id, params) when is_map(params) do
    Client.fetch(
      client,
      :patch,
      "/api/contacts/v1/properties/#{contact_property_id}",
      Parameters.for_request(params)
    )
  end

  def delete_property(client, contact_property_id) do
    Client.fetch(client, :delete, "/api/contacts/v1/properties/#{contact_property_id}")
  end

  def create_group(client, params) when is_map(params) do
    Client.fetch(client, :post, "/api/contacts/v1/groups/create", Parameters.for_request(params))
  end

  def list_groups(client, params \\ %{}) do
    Client.fetch(client, :get, "/api/contacts/v1/groups/list", nil, Parameters.for_query(params))
  end

  def get_group(client, group_id) do
    Client.fetch(client, :get, "/api/contacts/v1/groups/#{group_id}")
  end

  def update_group(client, group_id, params) when is_map(params) do
    Client.fetch(
      client,
      :patch,
      "/api/contacts/v1/groups/#{group_id}",
      Parameters.for_request(params)
    )
  end

  def delete_group(client, group_id) do
    Client.fetch(client, :delete, "/api/contacts/v1/groups/#{group_id}")
  end

  defdelegate add_group_contact(client, group_id, params), to: ContactGroups, as: :add_contact
  defdelegate remove_group_contact(client, group_id, params), to: ContactGroups, as: :remove_contact
  defdelegate list_group_contacts(client, group_id, params), to: ContactGroups, as: :list_contacts

  defdelegate create_channel(client, params), to: ContactChannels, as: :create
  defdelegate list_channels(client, params), to: ContactChannels, as: :list
  defdelegate get_channel(client, channel_id), to: ContactChannels, as: :get
  defdelegate update_channel(client, channel_id, params), to: ContactChannels, as: :update
  defdelegate delete_channel(client, channel_id), to: ContactChannels, as: :delete
  defdelegate add_channel_contact(client, channel_id, params), to: ContactChannels, as: :add_contact
  defdelegate update_channel_subscription(client, channel_id, params),
    to: ContactChannels,
    as: :update_subscription
end
