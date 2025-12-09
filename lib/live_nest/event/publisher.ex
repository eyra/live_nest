defmodule LiveNest.Event.Publisher do
  @moduledoc """
  A module for publishing events in LiveNest.

  Events are automatically routed based on the context of the socket:

  1. **Modal View** (`assigns.live_nest.modal.controller_pid`) - Events are sent to the
     Modal Controller that initiated the modal. This is set via `LiveNest.Modal.on_mount/4`.

  2. **Live Component** (`assigns.myself`) - Events are sent to the parent Live View via `self()`.

  3. **Embedded Live View** (`parent_pid`) - Events are sent to the parent Live View.

  4. **Routed Live View** (fallback) - Events are sent to `self()` for local handling.

  ## Note on Modal Presenters

  Modal Presenters (routed LiveViews that display modals) do NOT automatically route events
  to the Modal Controller. If a Modal Presenter needs to notify the Modal Controller
  (e.g., when a modal is closed), use `publish_event/3` with the `controller_pid`
  from the modal struct explicitly.
  """

  require Logger
  require LiveNest.Constants
  @event LiveNest.Constants.event()

  @doc """
  Publish an event to the appropriate recipient.

  Event can be a name, a tuple {atom, map}, or a %LiveNest.Event{} struct.
  Recipient will be determined by the context of the socket assigns.

  ## Examples

  ```elixir
  publish_event(socket, :user_updated)
  publish_event(socket, {:user_updated, %{user_id: 123}})
  publish_event(socket, %LiveNest.Event{name: :user_updated, payload: %{user_id: 123}})
  ```
  """
  # Modal View: has live_nest.modal in assigns (set via LiveNest.Modal.on_mount/4)
  def publish_event(
        %{assigns: %{live_nest: %{modal: %{controller_pid: controller_pid}}}} = socket,
        event
      )
      when not is_nil(controller_pid) do
    publish_event(socket, event, controller_pid)
  end

  # Live Component: publish to self (parent Live View)
  def publish_event(%{assigns: %{myself: _myself}} = socket, event) do
    publish_event(socket, event, self())
  end

  # Embedded Live View: publish to parent Live View
  def publish_event(%{parent_pid: parent_pid} = socket, event) when is_pid(parent_pid) do
    publish_event(socket, event, parent_pid)
  end

  # Routed Live View: publish to self
  def publish_event(socket, event) do
    publish_event(socket, event, self())
  end

  @doc """
  Publish an event to a specific pid.

  Use this when you need to send an event to a specific process, such as when a Modal Presenter
  needs to notify the Modal Controller that a modal was closed.

  ## Example

  ```elixir
  # In a Modal Presenter strategy, notify the Modal Controller
  def handle_close_modal(%{assigns: %{modal: %{controller_pid: pid}}} = socket, modal_id) do
    socket
    |> publish_event({:modal_closed, %{modal_id: modal_id}}, pid)
    |> assign(:modal, nil)
  end
  ```
  """
  def publish_event(socket, event, pid) when is_pid(pid) do
    source = {self(), socket.id}
    send(pid, {@event, prepare_event(event, source)})
    socket
  end

  defp prepare_event({name, payload}, source) when is_atom(name) and is_map(payload) do
    %LiveNest.Event{name: name, payload: payload, source: source}
  end

  defp prepare_event(name, source) when is_atom(name) do
    prepare_event({name, %{}}, source)
  end

  defp prepare_event(%LiveNest.Event{source: nil} = event, source) do
    # Add source to the event
    %LiveNest.Event{event | source: source}
  end

  defp prepare_event(%LiveNest.Event{} = event, _source) do
    # Event already prepared, don't overwrite source
    event
  end

  defmacro __using__(_opts) do
    quote do
      import LiveNest.Event.Publisher, only: [publish_event: 2]
    end
  end
end
