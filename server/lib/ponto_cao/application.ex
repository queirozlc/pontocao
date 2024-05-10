defmodule PontoCao.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PontoCaoWeb.Telemetry,
      PontoCao.Repo,
      {DNSCluster, query: Application.get_env(:ponto_cao, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PontoCao.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: PontoCao.Finch},
      # Start a worker by calling: PontoCao.Worker.start_link(arg)
      # {PontoCao.Worker, arg},
      # Start to serve requests, typically the last entry
      PontoCaoWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PontoCao.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PontoCaoWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
