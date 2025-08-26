defmodule LiveNest.Support.ConnCase do
  @moduledoc """
  A test case for testing with connections.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import Phoenix.LiveViewTest

      alias PhoenixApp.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint LiveNest.Support.TestEndpoint
    end
  end

  setup _tags do
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
