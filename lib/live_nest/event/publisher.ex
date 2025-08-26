defmodule LiveNest.Event.Publisher do
  @moduledoc """
  A module for publishing events in LiveNest.
  """

  require Logger
  require LiveNest.Constants
  @event LiveNest.Constants.event()

  def publish_event(socket, name, payload) do
    event = %LiveNest.Event{name: name, payload: payload}
    publish_event(socket, event)
  end

  def publish_event(%{assigns: %{modal_controller_pid: modal_controller_pid}} = socket, event)
      when not is_nil(modal_controller_pid) do
    send(modal_controller_pid, {@event, event})
    socket
  end

  def publish_event(%{assigns: %{myself: _myself}} = socket, event) do
    # The existence of `myself` is an indicator that this is a Live Component. Publish event to self (parent Live View).
    send(self(), {@event, event})
    socket
  end

  def publish_event(%{parent_pid: parent_pid} = socket, event) when is_pid(parent_pid) do
    send(parent_pid, {@event, event})
    socket
  end

  def publish_event(socket, event) do
    Logger.debug(
      "[Warning] No parent_pid or modal_controller_pid found, could not publish event: #{inspect(event)}"
    )

    socket
  end

  defmacro __using__(_opts) do
    quote do
      import LiveNest.Event.Publisher
    end
  end
end
