defmodule HelloExecWeb.MixProject do
  use Mix.Project

  def project do
    [
      app: :hello_exec_web,
      version: "0.1.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {HelloExecWeb.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.7.21"},
      {:phoenix_html, "~> 4.1"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 1.0"},
      {:floki, ">= 0.30.0", only: :test},
      {:esbuild, "~> 0.8", runtime: Mix.env() == :dev},
      {:tailwind, "~> 0.2.0", runtime: Mix.env() == :dev},
      {:heroicons,
       github: "tailwindlabs/heroicons",
       tag: "v2.1.1",
       sparse: "optimized",
       app: false,
       compile: false,
       depth: 1},
      {:telemetry_metrics, "~> 1.0"},
      {:telemetry_poller, "~> 1.0"},
      {:jason, "~> 1.2"},
      {:dns_cluster, "~> 0.1.1"},
      {:bandit, "~> 1.5"},
      {:elixirkit, path: ".."}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "assets.setup", "assets.build"],
      "assets.setup": ["tailwind.install --if-missing", "esbuild.install --if-missing"],
      "assets.build": ["tailwind hello_exec_web", "esbuild hello_exec_web"],
      "assets.deploy": [
        "tailwind hello_exec_web --minify",
        "esbuild hello_exec_web --minify",
        "phx.digest"
      ],
      clean: &clean_build/1
    ]
  end

  # カスタムタスク：build フォルダをクリーンアップ
  defp clean_build(_args) do
    # メインの _build フォルダをクリーンアップ
    if File.exists?("_build") do
      File.rm_rf("_build")
      IO.puts("✅ _build フォルダを削除しました")
    else
      IO.puts("ℹ️  _build フォルダは存在しません")
    end

    # rel/appkit の build フォルダをクリーンアップ
    appkit_build_path = "rel/appkit/.build"
    if File.exists?(appkit_build_path) do
      File.rm_rf(appkit_build_path)
      IO.puts("✅ rel/appkit/build フォルダを削除しました")
    else
      IO.puts("ℹ️  rel/appkit/build フォルダは存在しません")
    end
  end
end
