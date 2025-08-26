defmodule LiveNest.HTML do
  @moduledoc """
  This module implements helper HTML components:

  * element/1
  * live_view/1
  * component/1

  See also:
  - [LiveNest.Element](LiveNest.Element.html)
  """

  use Phoenix.Component


  @doc """
  Renders an element (LiveView, LiveComponent, or Component).
  """
  attr(:socket, :any, required: true)
  attr(:id, :any, required: true)
  attr(:type, :any, required: true)
  attr(:implementation, :any)
  attr(:options, :list, default: [])

  def element(%{type: :live_view, options: options} = assigns) do
    session = 
      options
      |> Enum.map(fn {key, value} -> {Atom.to_string(key), value} end)
      |> Enum.into(%{})

    assigns = Map.put(assigns, :session, session)

    ~H"""
      <.live_view socket={@socket} id={@id} module={@implementation} session={@session} />
    """
  end

  def element(%{type: :live_component, options: options} = assigns) do
    assigns = 
      Map.put(assigns, :params, Enum.into(options, %{}))

    ~H"""
      <.live_component id={@id} module={@implementation} {@params} />
    """
  end

  def element(%{type: :component, options: options} = assigns) do  
    assigns = 
      Map.put(assigns, :assigns, Enum.into(options, %{}))

    ~H"""
      <.component id={@id} function={@implementation} assigns={@assigns} />
    """
  end


  @doc """
  Renders a LiveView.
  """
  attr(:socket, :any, required: true)
  attr(:module, :any, required: true)
  attr(:id, :any, required: true)
  attr(:session, :any)

  def live_view(%{session: nil} = assigns) do
    live_view(assigns |> Map.put(:session, %{}))
  end

  def live_view(assigns) do
    ~H"""
    <div>
      {live_render(@socket, @module, id: @id, session: @session)}
    </div>
    """
  end

  @doc """
  Renders a Component.
  """ 
  attr(:id, :any, required: true)
  attr(:function, :any, required: true)
  attr(:assigns, :any)

  def component(assigns) do
    ~H"""
      <div id={@id}>
        {@function.(@assigns)}
      </div>
    """
  end
  
end
