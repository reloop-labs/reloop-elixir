defmodule Reloop.Services.ApiKey do
  alias Reloop.Client

  def create(client, params) do
    Client.fetch(client, :post, "/api-key/v1/", params)
  end

  def list(client, params \\ nil) do
    Client.fetch(client, :get, "/api-key/v1/", nil, params)
  end

  def get(client, id) do
    Client.fetch(client, :get, "/api-key/v1/#{id}")
  end

  def update(client, id, params) do
    Client.fetch(client, :patch, "/api-key/v1/#{id}", params)
  end

  def delete(client, id) do
    Client.fetch(client, :delete, "/api-key/v1/#{id}")
  end

  def rotate(client, id) do
    Client.fetch(client, :post, "/api-key/v1/rotate/#{id}")
  end

  def enable(client, id) do
    Client.fetch(client, :post, "/api-key/v1/enable/#{id}")
  end

  def disable(client, id) do
    Client.fetch(client, :post, "/api-key/v1/disable/#{id}")
  end
end
