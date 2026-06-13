defmodule Reloop.Services.ApiKey do
  @moduledoc """
  Manage API keys.
  """

  alias Reloop.Client
  alias Reloop.Support.Parameters

  def create(client, params) when is_map(params) do
    Client.fetch(client, :post, "/api/api-key/v1/", params)
  end

  def list(client, params \\ %{}) do
    Client.fetch(client, :get, "/api/api-key/v1/", nil, Parameters.for_query(params))
  end

  def get(client, id) do
    Client.fetch(client, :get, "/api/api-key/v1/#{id}")
  end

  def update(client, id, params) when is_map(params) do
    Client.fetch(client, :patch, "/api/api-key/v1/#{id}", params)
  end

  def delete(client, id) do
    Client.fetch(client, :delete, "/api/api-key/v1/#{id}")
  end

  def rotate(client, id) do
    Client.fetch(client, :post, "/api/api-key/v1/rotate/#{id}")
  end

  def enable(client, id) do
    Client.fetch(client, :post, "/api/api-key/v1/enable/#{id}")
  end

  def disable(client, id) do
    Client.fetch(client, :post, "/api/api-key/v1/disable/#{id}")
  end

  def pause(client, id) do
    disable(client, id)
  end
end
