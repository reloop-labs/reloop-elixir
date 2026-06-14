defmodule Reloop.MixProject do
  use Mix.Project

  @source_url "https://github.com/reloop-labs/reloop-elixir"

  def project do
    [
      app: :reloop,
      version: "0.1.2",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "Elixir SDK for the Reloop email API",
      package: package(),
      source_url: @source_url,
      homepage_url: "https://reloop.sh",
      docs: [
        main: "readme",
        extras: ["README.md"],
        source_url: @source_url
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:req, "~> 0.3.0"},
      {:jason, "~> 1.4"},
      {:bypass, "~> 2.1", only: :test},
      {:ex_doc, "~> 0.31", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      licenses: ["Apache-2.0"],
      links: %{
        "GitHub" => @source_url,
        "Documentation" => "https://reloop.sh/docs"
      },
      files: ~w(lib mix.exs README.md LICENSE CONTRIBUTING.md)
    ]
  end
end
