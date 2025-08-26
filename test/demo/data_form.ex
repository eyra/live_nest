defmodule LiveNest.Demo.Data.Form do
  @moduledoc """
  This module defines the demo modal live component.
  """

  use Phoenix.LiveComponent
  use LiveNest, :modal_live_component
  import LiveNest.Demo.HTML, only: [modal: 1]

  def update(%{id: id}, socket) do
    {
      :ok, 
      socket 
      |> assign(
        id: id,
        form: to_form(%{
          "show_total" => true,
          "show_active" => true,
          "show_new" => true
        })
      )
    }
  end

  def handle_event("change", params, socket) do
    config = %{
      show_total: params["show_total"] == "true",
      show_active: params["show_active"] == "true",
      show_new: params["show_new"] == "true"
    }
    {:noreply, socket |> publish_event(:update_settings, config)}
  end

  def handle_event("close_modal", _params, socket) do
    {:noreply, socket |> close_modal()}
  end

  defp close_modal(socket) do
    socket |> publish_event(@close_modal_event, %{})
  end
  
  def render(assigns) do
    ~H"""
    <div id={@id}>
      <.modal title="Data settings" target={@myself}>
        <.form phx-change="change" phx-target={@myself} for={@form}>
          <div class="form-group">
            <label>Display Options</label>
            <div class="checkbox-group">
              <label>
                <input id="show_total" type="checkbox" name="show_total"} />
                Show Total Users
              </label>
              <label>
                <input id="show_active" type="checkbox" name="show_active" />
                Show Active Users
              </label>
              <label>
                <input id="show_new" type="checkbox" name="show_new" />
                Show New Users
              </label>
            </div>
          </div>
        </.form>
      </.modal>
    </div>
    """
  end
end 