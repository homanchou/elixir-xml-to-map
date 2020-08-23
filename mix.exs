defmodule XmlToMap.Mixfile do
  use Mix.Project

  def project do
    [
      app: :elixir_xml_to_map,
      version: "2.0.0",
      elixir: "~> 1.9",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: "A module for converting an XML string to a map",
      package: package(),
      deps: deps()
    ]
  end

  def package do
    [
      maintainers: ["Homan Chou"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/homanchou/elixir-xml-to-map"}
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [extra_applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:erlsom, "~>1.4"},
      {:ex_doc, "~>0.21.3", only: :dev, runtime: false}
    ]
  end
end
