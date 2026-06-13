defmodule Reloop do
  @moduledoc """
  Reloop Elixir SDK.
  """

  defdelegate client(api_key, opts \\ []), to: Reloop.Client, as: :new
end
