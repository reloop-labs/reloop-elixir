defmodule Reloop.Client do
  defstruct [:api_key, :base_url]

  def new(api_key, opts \\ []) do
    if api_key == nil or api_key == "" do
      raise ArgumentError, "Reloop SDK requires an api_key"
    end

    %Reloop.Client{
      api_key: api_key,
      base_url: opts[:base_url] || "https://reloop.sh"
    }
  end

  def fetch(client, method, path, body \\ nil, params \\ nil) do
    url = client.base_url <> path
    
    headers = [
      {"x-api-key", client.api_key},
      {"user-agent", "reloop-elixir/0.1.3"},
      {"content-type", "application/json"},
      {"accept", "application/json"}
    ]

    req_opts = [
      method: method,
      url: url,
      headers: headers
    ]

    req_opts = if body, do: Keyword.put(req_opts, :json, body), else: req_opts
    req_opts = if params, do: Keyword.put(req_opts, :params, params), else: req_opts

    case Req.request(req_opts) do
      {:ok, %{status: status, body: response_body}} when status in 200..299 ->
        if status == 204 do
          {:ok, %{}}
        else
          {:ok, response_body}
        end

      {:ok, %{status: status, body: response_body}} ->
        {:error, "Reloop API Error: #{status} #{inspect(response_body)}"}

      {:error, reason} ->
        {:error, "Reloop Network Error: #{inspect(reason)}"}
    end
  end
end
