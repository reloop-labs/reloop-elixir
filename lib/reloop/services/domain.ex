defmodule Reloop.Services.Domain do
  @moduledoc """
  Manage sending and receiving domains.
  """

  alias Reloop.Client
  alias Reloop.Support.Parameters

  @doc """
  Creates a domain.

  Accepts snake_case keys such as `click_tracking`, `custom_return_path`, and `sending_email`.
  """
  def create(client, params) when is_map(params) do
    Client.fetch(client, :post, "/api/domain/v1/create", Parameters.for_snake_request(params))
  end

  @doc """
  Lists domains with optional filters: `page`, `limit`, `q`, and `status`.
  """
  def list(client, params \\ %{}) do
    Client.fetch(client, :get, "/api/domain/v1/list", nil, Parameters.for_query(params))
  end

  @doc """
  Retrieves a domain by ID.
  """
  def get(client, domain_id) do
    Client.fetch(client, :get, "/api/domain/v1/#{domain_id}")
  end

  @doc """
  Returns nameservers and DNS provider information for a domain.
  """
  def get_nameservers(client, domain_id) do
    Client.fetch(client, :get, "/api/domain/v1/nameservers/#{domain_id}")
  end

  @doc """
  Updates domain settings such as tracking and sending/receiving flags.
  """
  def update(client, domain_id, params) when is_map(params) do
    Client.fetch(
      client,
      :patch,
      "/api/domain/v1/#{domain_id}",
      Parameters.for_snake_request(params)
    )
  end

  @doc """
  Deletes a domain.
  """
  def delete(client, domain_id) do
    Client.fetch(client, :delete, "/api/domain/v1/#{domain_id}")
  end

  @doc """
  Verifies DNS records for a domain.
  """
  def verify(client, domain_id) do
    Client.fetch(client, :post, "/api/domain/v1/verify/#{domain_id}")
  end

  @doc """
  Forwards DNS configuration records to an email address.
  """
  def forward_dns(client, domain_id, params) when is_map(params) do
    Client.fetch(
      client,
      :post,
      "/api/domain/v1/verify/#{domain_id}/forward-dns",
      Parameters.for_snake_request(params)
    )
  end
end
