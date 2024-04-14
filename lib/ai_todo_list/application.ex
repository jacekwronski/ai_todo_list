defmodule AiTodoList.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AiTodoListWeb.Telemetry,
      AiTodoList.Repo,
      {DNSCluster, query: Application.get_env(:ai_todo_list, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: AiTodoList.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: AiTodoList.Finch},
      # Start a worker by calling: AiTodoList.Worker.start_link(arg)
      # {AiTodoList.Worker, arg},
      # Start to serve requests, typically the last entry
      AiTodoListWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AiTodoList.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AiTodoListWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
