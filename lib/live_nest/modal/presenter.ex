defmodule LiveNest.Modal.Presenter do
  @moduledoc """
  This module implements the ```Modal Presenter``` concept.
  LiveViews that use this module will receive events from the ```Modal Controller``` and handle them.

  The ```Modal Presenter``` is often the first LiveView in the LiveNest hierarchy.

  Example:
  ```
   defmodule MyApp.MyLiveView do
      use LiveNest.Modal.Presenter

      def handle_present_modal(socket, modal) do
          socket
      end

      def handle_hide_modal(socket, modal) do
          socket
      end

      def handle_close_modal(socket, modal_id) do
          socket
      end
  end
  ```
  """

  defmacro __using__(_opts) do
    quote do
      require LiveNest.Constants

      @present_modal_event LiveNest.Constants.present_modal_event()
      @hide_modal_event LiveNest.Constants.hide_modal_event()
      @close_modal_event LiveNest.Constants.close_modal_event()

      def consume_event(%{name: @present_modal_event, payload: modal}, socket) do
        {:stop, handle_present_modal(socket, modal)}
      end

      def consume_event(%{name: @hide_modal_event, payload: modal}, socket) do
        {:stop, handle_hide_modal(socket, modal)}
      end

      def consume_event(%{name: @close_modal_event, payload: modal_id}, socket) do
        {:stop, handle_close_modal(socket, modal_id)}
      end
    end
  end
end
