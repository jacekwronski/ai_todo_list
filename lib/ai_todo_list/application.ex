defmodule AiTodoList.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    Nx.global_default_backend(EXLA.Backend)

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
      AiTodoListWeb.Endpoint,
      {Nx.Serving,
       serving: AiTodoList.Model.serving(defn_options: [compiler: EXLA]),
       batch_size: 16,
       batch_timeout: 100,
       name: AiTodoListModel},
      {Nx.Serving,
       serving: AiTodoList.ActionsModel.serving(defn_options: [compiler: EXLA]),
       batch_size: 16,
       batch_timeout: 100,
       name: AiTodoListActionsModel}
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
