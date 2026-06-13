defmodule Reloop.Services.ContactGroups do
  @moduledoc false

  alias Reloop.Client
  alias Reloop.Support.Parameters

  def add_contact(client, group_id, params) when is_map(params) do
    Client.fetch(client, :post, "/api/contacts/group/#{group_id}", Parameters.for_request(params))
  end

  def remove_contact(client, group_id, params) when is_map(params) do
    Client.fetch(client, :delete, "/api/contacts/group/#{group_id}", Parameters.for_request(params))
  end

  def list_contacts(client, group_id, params \\ %{}) do
    Client.fetch(
      client,
      :get,
      "/api/contacts/v1/groups/#{group_id}/contacts",
      nil,
      Parameters.for_query(params)
    )
  end
end
