defmodule FlyIoTest.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    topologies = Application.get_env(:libcluster, :topologies) || []

    children = [
      # setup for clustering
      {Cluster.Supervisor, [topologies, [name: HelloElixir.ClusterSupervisor]]},
      # Start the Ecto repository
      FlyIoTest.Repo,
      # Start the Telemetry supervisor
      FlyIoTestWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: FlyIoTest.PubSub},
      # Start the Endpoint (http/https)
      FlyIoTestWeb.Endpoint
      # Start a worker by calling: FlyIoTest.Worker.start_link(arg)
      # {FlyIoTest.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FlyIoTest.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    FlyIoTestWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
