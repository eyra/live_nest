defmodule LiveNest.Demo.User.ProfileForm do
  @moduledoc """
  This module defines the demo modal live component.
  """

  use Phoenix.LiveComponent
  use LiveNest.Event.Publisher

  import LiveNest.Demo.HTML, only: [modal: 1]

  require LiveNest.Constants
  @close_modal_event LiveNest.Constants.close_modal_event()

  def update(%{id: id, live_nest: live_nest}, socket) do
    {
      :ok,
      socket
      |> assign(
        id: id,
        live_nest: live_nest,
        user: %{name: "Test User", email: "test@example.com"},
        form: to_form(%{"name" => "Test User", "email" => "test@example.com"})
      )
    }
  end

  def handle_event("cancel", _params, socket) do
    {:noreply, socket |> close_modal()}
  end

  def handle_event("save", _params, socket) do
    # No save action in this example
    {:noreply, socket |> close_modal()}
  end

  def handle_event("close_modal", _params, socket) do
    {:noreply, socket |> close_modal()}
  end

  defp close_modal(%{assigns: %{id: modal_id}} = socket) do
    socket |> publish_event({@close_modal_event, %{modal_id: modal_id}})
  end

  def render(assigns) do
    ~H"""
    <div id={@id}>
      <.modal title="Edit Profile" target={@myself}>
        <form phx-submit="save">
          <div class="form-group">
            <label>Name</label>
            <input type="text" name="name" value={@form["name"].value} />
          </div>

          <div class="form-group">
            <label>Email</label>
            <input type="email" name="email" value={@form["email"].value} />
          </div>

          <div class="form-actions">
            <button type="button" phx-click="cancel">Cancel</button>
            <button type="submit">Save Changes</button>
          </div>
        </form>
      </.modal>
    </div>
    """
  end
end
