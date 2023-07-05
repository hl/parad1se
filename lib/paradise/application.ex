defmodule Paradise.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ParadiseWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Paradise.PubSub},
      # Start Finch
      {Finch, name: Paradise.Finch},
      # Start the Endpoint (http/https)
      ParadiseWeb.Endpoint,
      # CubDB
      {CubDB, cubdb_config()},
      # Process Registry
      {Registry, [keys: :unique, name: Paradise.Registry]},
      # Partition Supervisors
      {PartitionSupervisor, child_spec: DynamicSupervisor, name: Paradise.DynamicSupervisors},
      # ETS
      {Paradise.AstronautStorage, []},
      {Paradise.PlanetStorage, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Paradise.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ParadiseWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  @spec cubdb_config() :: Keyword.t()
  def cubdb_config do
    Application.get_env(:paradise, CubDB)
  end
end
