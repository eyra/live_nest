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
  @type modal_controller_pid :: pid()
  @type element :: LiveNest.Element.t()
  @type options :: keyword()

  @type t :: %__MODULE__{
          style: style(),
          visible: visible(),
          modal_controller_pid: modal_controller_pid(),
          element: element(),
          options: options()
        }

  defstruct [
    :style,
    :visible,
    :modal_controller_pid,
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
    session = enrich_element_options(session)
    element = LiveNest.Element.prepare_live_view(id, module, session)
    prepare_modal(options, element)
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
    params = enrich_element_options(params)
    element = LiveNest.Element.prepare_live_component(id, module, params)
    prepare_modal(options, element)
  end

  defp prepare_modal(options, element) do
    {style, options} = Keyword.pop(options, :style, :default)
    {visible, options} = Keyword.pop(options, :visible, true)

    %LiveNest.Modal{
      style: style,
      visible: visible,
      options: options,
      modal_controller_pid: self(),
      element: element
    }
  end

  defp enrich_element_options(options) when is_list(options) do
    Keyword.put(options, :modal_controller_pid, self())
  end

  @doc """
  On mount callback for LiveViews that initializes the modal controller pid.
  """
  def on_mount(:initialize, _params, session, socket) do
    modal_controller_pid = Map.get(session, "modal_controller_pid")
    {:cont, socket |> Phoenix.Component.assign(modal_controller_pid: modal_controller_pid)}
  end

  @doc """
  LiveView macro that initializes the modal controller pid.
  """
  def live_view do
    quote do
      on_mount({LiveNest.Modal, :initialize})
    end
  end

  @doc """
  LiveComponent macro that initializes the modal controller pid.
  """
  def live_component do
    quote do
      def update(%{modal_controller_pid: modal_controller_pid} = params, socket) do
        params = Map.drop(params, [:modal_controller_pid])

        update(
          params,
          socket |> Phoenix.Component.assign(modal_controller_pid: modal_controller_pid)
        )
      end
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
