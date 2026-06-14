defmodule Reloop.Services.Mail do
  @moduledoc """
  Send transactional email.
  """

  alias Reloop.Client
  alias Reloop.Support.Parameters

  @doc """
  Sends an email through Reloop.

  Accepts snake_case keys such as `from`, `to`, `subject`, `reply_to`, and `template`.
  """
  def send(client, params) when is_map(params) do
    Client.fetch(client, :post, "/api/mail/v1/send", Parameters.for_snake_request(params))
  end
end
