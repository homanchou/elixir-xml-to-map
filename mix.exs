defmodule XmlToMap.Mixfile do
  use Mix.Project

  @source_url "https://github.com/homanchou/elixir-xml-to-map"

  def project do
    [
      app: :elixir_xml_to_map,
      version: "2.0.0",
      elixir: "~> 1.9",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: "A module for converting an XML string to a map",
      package: package(),
      deps: deps(),
      docs: docs()
    ]
  end

  def package do
    [
      maintainers: ["Homan Chou"],
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => @source_url}
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:erlsom, "~> 1.4"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      main: "readme",
      source_url: @source_url,
      extras: ["README.md"]
    ]
  end
end
