defmodule LiveNest.Event.Consumer do
  @moduledoc """
  A behaviour for handling events in LiveNest.
  """

  alias Phoenix.LiveView.Socket
  alias LiveNest.Event

  @callback consume_event(event :: Event.t(), socket :: Socket.t()) ::
              {:continue, Socket.t()} | {:stop, Socket.t()}

  defmacro __using__(_opts) do
    quote do
      @behaviour LiveNest.Event.Consumer
      require Logger

      alias LiveNest.Event

      def handle_info({@event, event} = message, socket) do
        {
          :noreply,
          event
          |> consume_event(socket)
          |> handle_consumed_event(event)
        }
      end

      def handle_consumed_event({:continue, socket}, event) do
        socket |> Event.Publisher.publish_event(event)
      end

      def handle_consumed_event({:stop, socket}, _event) do
        socket
      end

      def handle_consumed_event(result, _event) do
        raise "Incorrect result from consume_event/2: #{inspect(result)}"
      end

      @before_compile {LiveNest.Event.Consumer, :add_fallback_behaviour}
    end
  end

  defmacro add_fallback_behaviour(_env) do
    quote do
      def consume_event(event, socket) do
        Logger.debug(
          "[Warning] #{__MODULE__}.consume_event/2 not implemented for event #{inspect(event)}"
        )

        {:continue, socket}
      end
    end
  end
end
