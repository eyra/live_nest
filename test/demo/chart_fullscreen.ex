defmodule LiveNest.Demo.Chart.Fullscreen do
  @moduledoc """
  This module defines the demo modal live view.
  """

  use Phoenix.LiveView
  use LiveNest, :modal_live_view

  import LiveNest.Demo.HTML, only: [modal: 1]

  def mount(:not_mounted_at_router, _session, socket) do
    {:ok, socket}
  end

  def handle_event("close_modal", _params, %{assigns: %{element_id: modal_id}} = socket) do
    {:noreply, socket |> publish_event({@close_modal_event, %{modal_id: modal_id}})}
  end

  def handle_event("ping_controller", _params, socket) do
    {:noreply, socket |> publish_event(:ping_from_modal)}
  end

  def render(assigns) do
    ~H"""
    <div>
      <.modal title="Fullscreen chart view" target="">
        <p class="text-sm text-gray-500 mt-2">Chart ID: { @element_id }</p>
        <button phx-click="ping_controller" class="mt-2 px-2 py-1 bg-blue-500 text-white rounded">
          Ping Controller
        </button>
      </.modal>
    </div>
    """
  end
end
