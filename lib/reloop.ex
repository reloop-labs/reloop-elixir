defmodule Reloop do
  defdelegate client(api_key, opts \\ []), to: Reloop.Client, as: :new
end
