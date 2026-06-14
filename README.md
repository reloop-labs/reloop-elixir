# Reloop Elixir SDK

## Before you send

You need two things:

1. **API key** — create one in your Reloop account
2. **Verified domain** — add and verify a sending domain; use it in the `from` address

For setup details and the full API reference, see [reloop.sh/docs](https://reloop.sh/docs).

## Send email

```elixir
# mix.exs
{:reloop, "~> 1.8.0"}
```

```elixir
client = Reloop.client("rl_your_api_key_here")

{:ok, result} =
  Reloop.Services.Mail.send(client, %{
    from: "Reloop <hello@your-verified-domain.com>",
    to: "user@example.com",
    subject: "Welcome to Reloop",
    html: "<p>Thanks for signing up.</p>",
    text: "Thanks for signing up.",
  })

IO.inspect(result["messageId"])
```

More examples and optional fields: [reloop.sh/docs](https://reloop.sh/docs)
