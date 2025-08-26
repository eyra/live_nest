defmodule LiveNest do
  @moduledoc """
  A collection of macros and functions to help you build applications with nested LiveViews.
  """

  def routed_live_view do
    quote do
      unquote(live_view())
      use LiveNest.Modal.Presenter
    end
  end

  def embedded_live_view do
    quote do
      unquote(live_view())
      use LiveNest.Event.Publisher

      on_mount({LiveNest.Element, :initialize})
    end
  end

  def modal_live_view do
    quote do
      unquote(embedded_live_view())
      use LiveNest.Modal, :live_view
    end
  end

  def modal_live_component do
    quote do
      unquote(live_component())
      use LiveNest.Modal, :live_component
    end
  end

  def live_view do
    quote do
      use LiveNest.Constants
      use LiveNest.Event.Consumer
      use LiveNest.Modal.Controller

      import LiveNest.HTML
    end
  end

  def live_component do
    quote do
      use LiveNest.Constants
      use LiveNest.Event.Publisher

      import LiveNest.HTML
    end
  end

  def modal_presenter_strategy do
    quote do
      @behaviour LiveNest.Modal.Presenter.Strategy
    end
  end

  def single_modal_presenter_strategy do
    quote do
      use LiveNest.Modal.Presenter.Strategy.Single
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
