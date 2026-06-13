# Reloop Elixir SDK

Official Elixir client for the [Reloop](https://reloop.sh) API.

## Install

Add `reloop` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:reloop, "~> 0.1.0"}
  ]
end
```

## Usage

```elixir
client = Reloop.client("rl_your_api_key_here")
```

## Domains

Manage sending and receiving domains via `Reloop.Services.Domain`. Pass snake_case map keys; responses are decoded JSON maps from the API.

```elixir
client = Reloop.client("rl_your_api_key_here")

{:ok, domain} =
  Reloop.Services.Domain.create(client, %{
    domain: "send.example.com",
    custom_return_path: "inbound",
    click_tracking: true,
    open_tracking: true,
    tls: "opportunistic",
    sending_email: true,
    receiving_email: true
  })

{:ok, list} =
  Reloop.Services.Domain.list(client, %{page: 1, limit: 10, status: "active"})

{:ok, one} = Reloop.Services.Domain.get(client, "domain_123456789")

{:ok, updated} =
  Reloop.Services.Domain.update(client, "domain_123456789", %{
    click_tracking: false,
    sending_email: true
  })

{:ok, status} = Reloop.Services.Domain.verify(client, "domain_123456789")

{:ok, forwarded} =
  Reloop.Services.Domain.forward_dns(client, "domain_123456789", %{
    email: "admin@example.com"
  })

{:ok, nameservers} = Reloop.Services.Domain.get_nameservers(client, "domain_123456789")
IO.inspect(nameservers["dnsProvider"])

{:ok, deleted} = Reloop.Services.Domain.delete(client, "domain_123456789")
```

## API Keys

```elixir
client = Reloop.client("rl_your_api_key_here")

{:ok, api_key} = Reloop.Services.ApiKey.create(client, %{name: "Production Key"})
{:ok, list} = Reloop.Services.ApiKey.list(client, %{page: 1, limit: 10})
{:ok, one} = Reloop.Services.ApiKey.get(client, "key_id_here")
{:ok, updated} = Reloop.Services.ApiKey.update(client, "key_id_here", %{name: "Renamed Key"})
{:ok, deleted} = Reloop.Services.ApiKey.delete(client, "key_id_here")
{:ok, rotated} = Reloop.Services.ApiKey.rotate(client, "key_id_here")
{:ok, paused} = Reloop.Services.ApiKey.pause(client, "key_id_here")
{:ok, enabled} = Reloop.Services.ApiKey.enable(client, "key_id_here")
```

## Contacts

```elixir
client = Reloop.client("rl_your_api_key_here")

{:ok, contact} =
  Reloop.Services.Contacts.create(client, %{
    email: "user@example.com",
    first_name: "Ada",
    last_name: "Lovelace"
  })

{:ok, list} = Reloop.Services.Contacts.list(client, %{page: 1, limit: 10})
{:ok, one} = Reloop.Services.Contacts.get(client, "contact_id_here")
{:ok, group} = Reloop.Services.Contacts.create_group(client, %{name: "Beta Testers"})
{:ok, channel} = Reloop.Services.Contacts.create_channel(client, %{name: "Newsletter"})
{:ok, subscribed} =
  Reloop.Services.Contacts.add_channel_contact(client, "channel_id_here", %{
    contact_id: "contact_id_here"
  })
```

## License

MIT
