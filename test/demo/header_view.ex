defmodule LiveNest.Demo.Header.View do
  @moduledoc """
  This module defines the demo embedded live view (1st level of nesting).
  """

  use Phoenix.LiveView
  use LiveNest, :embedded_live_view

  @impl true
  def mount(_params, %{"id" => id, "title" => title}, socket) do
    profile_form = LiveNest.Modal.prepare_live_component("profile-form", LiveNest.Demo.User.ProfileForm)
    
    {
      :ok,
      socket
      |> assign(
        id: id,
        title: title,
        user: %{name: "Test User", email: "test@example.com"},
        modal_closed_count: 0,
        profile_form: profile_form
      )
    }
  end

  @impl true
  def handle_event("show_profile", _params, %{assigns: %{profile_form: profile_form}} = socket) do
    {:noreply, socket |> present_modal(profile_form)}
  end

  require LiveNest.Constants
  @close_modal_event LiveNest.Constants.close_modal_event

  @doc """
    Intercept the close modal event and update the modal closed count.
    Bubble the event to the parent processes to handle the actual modal close.
  """
  @impl true
  def consume_event(%{name: @close_modal_event, payload: "profile-form"}, %{assigns: %{modal_closed_count: count}} = socket) do
    {:continue, socket |> assign(modal_closed_count: count + 1)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <header class="app-header">
      <div class="header-left">
        <h1><%= @title %></h1>
      </div>

      <div class="header-right">
        <div>Profile form modal closed { @modal_closed_count } times</div>
        <button phx-click="show_profile" class="profile-button">
          <%= @user.name %>
        </button>
      </div>
    </header>
    """
  end
end 