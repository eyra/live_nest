defmodule LiveNest.Support.TestApplication do
  use Application

  @impl true
  def start(_type, _args) do
    children = []

    opts = [strategy: :one_for_one, name: LiveNest.Supervisor]
    Supervisor.start_link(children, opts)
  end
end 