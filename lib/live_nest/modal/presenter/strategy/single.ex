defmodule LiveNest.Modal.Presenter.Strategy.Single do
  @moduledoc """
  A strategy for presenting a single modal at a time.
  """

  defmacro __using__(_opts) do
    quote do
      @behaviour LiveNest.Modal.Presenter.Strategy

      import LiveNest.HTML

      require Logger

      alias LiveNest.Element
      alias LiveNest.Event
      alias LiveNest.Modal

      def handle_present_modal(socket, %Modal{} = modal) do
        socket |> assign(:modal, modal)
      end

      def handle_hide_modal(
            %{assigns: %{modal: %Modal{element: %Element{id: current_modal_id}}}} = socket,
            %Modal{element: %Element{id: modal_id}}
          )
          when current_modal_id == modal_id do
        socket |> assign(:modal, nil)
      end

      def handle_hide_modal(
            %{assigns: %{modal: %Modal{element: %Element{id: current_modal_id}}}} = socket,
            %Modal{element: %Element{id: modal_id}}
          ) do
        Logger.warning(
          "Trying to hide modal #{modal_id} but found current modal to be #{current_modal_id}"
        )

        socket
      end

      def handle_close_modal(
            %{assigns: %{modal: %{element: %Element{id: current_modal_id}} = modal}} = socket,
            modal_id
          )
          when current_modal_id == modal_id do
        socket |> assign(:modal, nil)
      end

      def handle_close_modal(
            %{assigns: %{modal: %Element{id: current_modal_id}}} = socket,
            modal_id
          ) do
        Logger.warning(
          "Trying to close modal #{modal_id} but found current modal to be #{current_modal_id}"
        )

        socket
      end

      def handle_close_modal(socket, modal_id) do
        Logger.warning("Trying to close modal #{modal_id} but no modal is present")
        socket
      end
    end
  end
end
