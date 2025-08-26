defmodule LiveNest.Support.TestRouter do
  @moduledoc """
  A router for testing the LiveNest framework.
  """

  use Phoenix.Router
  import Phoenix.LiveView.Router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
  end

  scope "/" do
    pipe_through(:browser)
    live("/dashboard", LiveNest.Demo.Dashboard.Page)
  end
end
