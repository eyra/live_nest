defmodule LiveNest.Constants do
  @moduledoc """
  This module contains the LiveNest constants.
  """

  defmacro event, do: :live_nest_event
  defmacro present_modal_event, do: :present_modal
  defmacro hide_modal_event, do: :hide_modal
  defmacro close_modal_event, do: :close_modal
  defmacro modal_closed_event, do: :modal_closed

  defmacro __using__(_) do
    quote do
      require LiveNest.Constants
      @event LiveNest.Constants.event()
      @present_modal_event LiveNest.Constants.present_modal_event()
      @hide_modal_event LiveNest.Constants.hide_modal_event()
      @close_modal_event LiveNest.Constants.close_modal_event()
      @modal_closed_event LiveNest.Constants.modal_closed_event()
    end
  end
end
