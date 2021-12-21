defmodule Vitalstatistix.MixProject do
  use Mix.Project

  def project do
    [
      app: :vitalstatistix,
      version: "0.2.0",
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
      extra_applications: [:logger, :statix]
    ]
  end

  defp deps do
    [
      # statix is the underlying statsd socket
      {:statix, "~> 1.4"},
      # plug is required because we provide per request statistics
      {:plug, "~> 1.12"}
    ]
  end
end
