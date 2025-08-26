defmodule LiveNest.Demo.Dashboard.View do
  @moduledoc """
  This module defines the demo embedded live view (1st level of nesting).
  """

  use Phoenix.LiveView
  use LiveNest, :embedded_live_view
  use LiveNest.Modal, :live_view

  def mount(:not_mounted_at_router, _session, socket) do
    {
      :ok, 
      socket |> assign_widgets()
    }
  end

  def assign_widgets(socket) do
    assign(socket,
      widgets: [
        LiveNest.Element.prepare_live_view("data-widget", LiveNest.Demo.Data.Widget, title: "User Stats"),
        LiveNest.Element.prepare_live_view("chart-widget", LiveNest.Demo.Chart.Widget, title: "Activity Chart") 
      ]
    )
  end
  
  def render(assigns) do
    ~H"""
      <div class="dashboard-content">
        <%= for widget <- @widgets do %>
          <.element socket={@socket} {Map.from_struct(widget)} />
        <% end %>
      </div>
    """
  end
end 