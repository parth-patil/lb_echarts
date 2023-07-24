defmodule LbEcharts.MixProject do
  use Mix.Project

  def project do
    [
      app: :lb_echarts,
      version: "0.0.1",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      name: "lb_echarts",
      source_url: "https://github.com/parth-patil/lb_echarts"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:kino, "~> 0.10.0"},
      {:jason, "~> 1.4"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp description do
    """
    Library to use Echarts in LiveBook
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*"],
      maintainers: ["Parth Patil", "Trupti Hosamani"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/parth-patil/lb_echarts"}
    ]
  end
end
