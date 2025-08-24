defmodule HelloExecWeb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      HelloExecWebWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:hello_exec_web, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: HelloExecWeb.PubSub},
      # Start to serve requests, typically the last entry
      HelloExecWebWeb.Endpoint
    ]

    # Only start ElixirKit server when ELIXIRKIT_PORT is set (when launched from Swift)
    children = if System.get_env("ELIXIRKIT_PORT") do
      # Add ElixirKit server with restart strategy
      elixirkit_spec = %{
        id: HelloExecWeb.Server,
        start: {HelloExecWeb.Server, :start_link, [nil]},
        restart: :permanent,
        type: :worker
      }
      List.insert_at(children, -1, elixirkit_spec)
    else
      children
    end

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    # Use rest_for_one strategy to restart dependent processes if ElixirKit fails
    opts = [
      strategy: :one_for_one,
      name: HelloExecWeb.Supervisor,
      max_restarts: 10,
      max_seconds: 60
    ]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    HelloExecWebWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
