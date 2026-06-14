# Contributing to the Reloop Elixir SDK

Hex package: **`reloop`**.

**License:** [Apache License 2.0](./LICENSE) with additional use restrictions from Reloop Labs.

**API reference:** [reloop.sh/docs](https://reloop.sh/docs)

Port new endpoints from the [Node.js SDK](https://github.com/reloop-labs/reloop-node) reference.

---

## Development setup

```bash
git clone git@github.com:reloop-labs/reloop-elixir.git
cd reloop-elixir
mix deps.get
mix test
```

Requires **Elixir 1.12+** / **OTP 24+**.

---

## Project layout

```
lib/reloop/
  client.ex
  support/parameters.ex
  services/             # mail.ex, domain.ex, …
test/reloop/services/   # Bypass HTTP tests
mix.exs                 # version, licenses
```

---

## Conventions

| Topic | Rule |
|-------|------|
| Mail & domain | `Parameters.for_snake_request/1` |
| Contacts | `Parameters.for_request/1` |
| Tests | `Bypass` — assert path and JSON body |
| Public API | `Reloop.Services.*` module functions |

---

## Pull request checklist

- [ ] `mix test` passes
- [ ] `mix.exs` version bumped only for releases

---

## Releasing

Version: **`mix.exs`** → `version:`.

```bash
git commit -am "chore: release v1.9.0"
git push origin main
git tag v1.9.0
git push origin v1.9.0
```

[`.github/workflows/release.yml`](./.github/workflows/release.yml) uploads source zip + Hex tarball.

Publish: `mix hex.publish` via [`.github/workflows/publish.yml`](./.github/workflows/publish.yml).
