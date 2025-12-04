defmodule LiveNest.Demo.Data.Widget do
  @moduledoc """
  This module defines the demo embedded live view (2nd level of nesting).
  """

  use Phoenix.LiveView
  use LiveNest, :embedded_live_view

  def mount(:not_mounted_at_router, %{"title" => title}, socket) do
    {
      :ok,
      socket
      |> assign(title: title)
      |> assign(
        config: %{
          show_total: true,
          show_active: true,
          show_new: true
        }
      )
    }
  end

  def handle_event("settings", _params, socket) do
    modal = LiveNest.Modal.prepare_live_component("data-form", LiveNest.Demo.Data.Form)
    {:noreply, publish_event(socket, @present_modal_event, %{modal: modal})}
  end

  def consume_event(%{name: :update_settings, payload: %{config: config}}, socket) do
    {:continue, socket |> assign(config: config)}
  end

  def render(assigns) do
    ~H"""
    <div class="data-widget">
      <div class="widget-header">
        <h3><%= @title %></h3>
        <button phx-click="settings">Settings</button>
      </div>

      <div class="widget-content">
        <div id="total-users" :if={@config.show_total}>
          <span class="label">Total Users</span>
          <span class="value">1,234</span>
        </div>
        <div id="active-users" :if={@config.show_active}>
          <span class="label">Active Now</span>
          <span class="value">42</span>
        </div>
        <div id="new-users" :if={@config.show_new}>
          <span class="label">New Today</span>
          <span class="value">15</span>
        </div>
      </div>
    </div>
    """
  end
end
