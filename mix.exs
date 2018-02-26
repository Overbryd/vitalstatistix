defmodule Vitalstatistix.MixProject do
  use Mix.Project

  def project do
    [
      app: :vitalstatistix,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "An application statistic library for statsd/datadog",
      package: [
        licenses: ["GNU LGPL"],
        maintainers: ["Lukas Rieder"],
        links: %{}
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      # statix is the underlying statsd socket
      {:statix, "~> 1.1.0"},
      # plug is required because we provide per request statistics
      {:plug, "~> 1.0"}
    ]
  end
end
