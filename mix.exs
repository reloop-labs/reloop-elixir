defmodule Reloop.MixProject do
  use Mix.Project

  def project do
    [
      app: :reloop,
      version: "1.8.0",
      elixir: "~> 1.12",
      licenses: ["Apache-2.0"],
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
      {:bypass, "~> 2.1", only: :test}
    ]
  end
end
