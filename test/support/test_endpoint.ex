defmodule LiveNest.Support.TestEndpoint do
  @moduledoc """
  A test endpoint for the LiveNest framework.
  """

  use Phoenix.Endpoint, otp_app: :live_nest

  socket("/live", Phoenix.LiveView.Socket)

  plug(Plug.Session,
    store: :cookie,
    key: "_test_key",
    signing_salt: "test_signing_salt"
  )

  plug(LiveNest.Support.TestRouter)
end
