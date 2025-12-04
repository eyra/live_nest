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
    {:noreply, socket |> publish_event(@close_modal_event, %{modal_id: modal_id})}
  end

  def render(assigns) do
    ~H"""
    <div>
      <.modal title="Fullscreen chart view" target="">
        <p class="text-sm text-gray-500 mt-2">Chart ID: { @element_id }</p>
      </.modal>
    </div>
    """
  end
end
