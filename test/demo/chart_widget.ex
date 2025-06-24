defmodule LiveNest.Demo.Chart.Widget do
  @moduledoc """
  This module defines the demo embedded live view (2nd level of nesting).
  """

  use Phoenix.LiveView
  use LiveNest, :embedded_live_view

  def mount(:not_mounted_at_router, %{"title" => title}, socket) do
    chart_fullscreen_modal =
      LiveNest.Modal.prepare_live_view("chart-fullscreen", LiveNest.Demo.Chart.Fullscreen,
        session: [id: "1"]
      )

    {
      :ok,
      socket
      |> assign(
        title: title,
        chart_fullscreen_modal: chart_fullscreen_modal
      )
    }
  end

  def handle_event(
        "maximize",
        _,
        %{assigns: %{chart_fullscreen_modal: chart_fullscreen_modal}} = socket
      ) do
    {:noreply, socket |> present_modal(chart_fullscreen_modal)}
  end

  def render(assigns) do
    ~H"""
    <div class="bg-white rounded-lg shadow p-4">
      <div class="flex justify-between items-center mb-4">
        <h3 class="text-lg font-medium text-gray-900">{ @title }</h3>
        <button phx-click="maximize" class="text-gray-500 hover:text-gray-700">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 8V4m0 0h4M4 4l5 5m11-1V4m0 0h-4m4 0l-5 5M4 16v4m0 0h4m-4 0l5-5m11 5v-4m0 4h-4m4 0l-5-5" />
          </svg>
        </button>
      </div>

      <div class="h-48 flex items-center justify-center">
        <div class="text-center">
          <p class="text-gray-600">Chart widget content</p>
          <p class="text-sm text-gray-500 mt-2">ID: <%= @element_id %></p>
        </div>
      </div>
    </div>
    """
  end
end
