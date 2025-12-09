defmodule LiveNest.Modal do
  @moduledoc """
  This module defines the Modal struct, which serves as a reference mechanism for modal views in the LiveNest framework.
  ``` LiveNest.Modal``` uses ``` LiveNest.Element``` to reference LiveViews, LiveComponents, and Components.

  See also:
  - [LiveNest.Element](LiveNest.Element.html)
  """

  @type id :: atom() | binary()
  @type style :: atom()
  @type visible :: boolean()
  @type controller_pid :: pid()
  @type element :: LiveNest.Element.t()
  @type options :: keyword()

  @type t :: %__MODULE__{
          style: style(),
          visible: visible(),
          controller_pid: controller_pid(),
          element: element(),
          options: options()
        }

  defstruct [
    :style,
    :visible,
    :controller_pid,
    :element,
    :options
  ]

  @doc """
  Prepares a modal referencing a LiveView.
  ## Options
  - `:style` - The style of the modal, defaults to `:default`.
  - `:visible` - Whether the modal is visible, defaults to `true`. Can be used to preload the liveview in the background.
  - `:session` - A keyword list of session variables to be passed to the LiveView.
  """
  @spec prepare_live_view(id(), module(), keyword()) :: t()
  def prepare_live_view(id, module, options \\ []) when is_atom(module) do
    {session, options} = Keyword.pop(options, :session, [])
    element = LiveNest.Element.prepare_live_view(id, module, session)
    modal = prepare_modal(options, element)

    # Add live_nest context to element options so Modal View can access the modal
    element_options = Keyword.put(element.options, :live_nest, %{modal: modal})
    %{modal | element: %{element | options: element_options}}
  end

  @doc """
  Prepares a modal referencing a LiveComponent.
  ## Options
  - `:style` - The style of the modal, defaults to `:default`.
  - `:visible` - Whether the modal is visible, defaults to `true`. Can be used to preload the livecomponent in the background.
  - `:params` - A keyword list of params to be passed to the LiveComponent.
  """
  @spec prepare_live_component(id(), module(), keyword()) :: t()
  def prepare_live_component(id, module, options \\ []) when is_atom(module) do
    {params, options} = Keyword.pop(options, :params, [])
    element = LiveNest.Element.prepare_live_component(id, module, params)
    modal = prepare_modal(options, element)

    # Add live_nest context to element options so Modal View can access the modal
    element_options = Keyword.put(element.options, :live_nest, %{modal: modal})
    %{modal | element: %{element | options: element_options}}
  end

  defp prepare_modal(options, element) do
    {style, options} = Keyword.pop(options, :style, :default)
    {visible, options} = Keyword.pop(options, :visible, true)

    %LiveNest.Modal{
      style: style,
      visible: visible,
      options: options,
      controller_pid: self(),
      element: element
    }
  end

  @doc """
  On mount callback for LiveViews that initializes the LiveNest context.
  """
  def on_mount(:initialize, _params, session, socket) do
    live_nest = Map.get(session, "live_nest", %{})
    {:cont, socket |> Phoenix.Component.assign(live_nest: live_nest)}
  end

  @doc """
  LiveView macro that initializes the LiveNest context.
  """
  def live_view do
    quote do
      on_mount({LiveNest.Modal, :initialize})
    end
  end

  @doc """
  LiveComponent macro that initializes the LiveNest context.
  """
  def live_component do
    quote do
      def update(%{live_nest: live_nest} = params, socket) do
        params = Map.drop(params, [:live_nest])

        update(
          params,
          socket |> Phoenix.Component.assign(live_nest: live_nest)
        )
      end
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
