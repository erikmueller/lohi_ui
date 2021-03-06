defmodule LohiUi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the endpoint when the application starts
      LohiUiWeb.Endpoint,
      LohiUi.Player,
      LohiUi.MpdMonitor
      # Starts a worker by calling: LohiUi.Worker.start_link(arg)
      # {LohiUi.Worker, arg},
    ]

    # unblock paracusia application start - to continue lohi app
    # boot order (which boots paracusia before mpd)
    spawn(Application, :start, [:paracusia])

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LohiUi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    LohiUiWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
