defmodule LiveNest.Demo.Dashboard.Page do
    @moduledoc """
    This module defines the demo routed live view.
    """

    use Phoenix.LiveView
    use LiveNest, :routed_live_view
    use LiveNest, :single_modal_presenter_strategy

    import LiveNest.HTML
    import LiveNest.Demo.HTML, only: [footer: 1]
    
    def mount(_params, _session, socket) do
        {:ok, socket |> assign(modal: nil, footer: "")}
    end

    def consume_event(%{name: :update_settings}, socket) do
        {:continue, socket |> assign(footer: "Settings updated")}
    end

    def render(assigns) do
        ~H"""
        <div class="relative">
            <div :if={@modal}>
                <.element socket={@socket} {Map.from_struct(@modal.element)} />
            </div>

            <div class="sticky top-0 z-10 bg-white">
                {live_render(@socket, LiveNest.Demo.Header.View, id: "header", session: %{"id" => "header", "title" => "Dashboard"})}
            </div>
            {live_render(@socket, LiveNest.Demo.Dashboard.View, id: "dashboard", session: %{"id" => "dashboard"})}
            <.footer text={@footer} />
        </div>
        """
    end
end