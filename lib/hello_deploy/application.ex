defmodule HelloDeploy.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      HelloDeployWeb.Telemetry,
      HelloDeploy.Repo,
      {DNSCluster, query: Application.get_env(:hello_deploy, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: HelloDeploy.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: HelloDeploy.Finch},
      # Start a worker by calling: HelloDeploy.Worker.start_link(arg)
      # {HelloDeploy.Worker, arg},
      # Start to serve requests, typically the last entry
      HelloDeployWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HelloDeploy.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    HelloDeployWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
