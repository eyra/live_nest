# LiveNest

A robust framework for architecting sophisticated web applications with Phoenix LiveView. LiveNest delivers a structured framework for organizing LiveViews, implementing modal interfaces, and managing event propagation in Phoenix applications.

## Features

- **Hierarchical Architecture**: Construct complex interfaces through composition of modular LiveViews
- **Modal System**: Comprehensive modal management with support for both LiveView and LiveComponent implementations
- **Event Propagation**: Sophisticated event handling system with controlled propagation through the LiveView hierarchy
- **HTML Utilities**: Enhanced HTML helpers for streamlined development
- **Type Safety**: Comprehensive constant definitions and type specifications

## Installation

Add `live_nest` to your project dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:live_nest, "~> 0.1.0"}
  ]
end
```

## Usage

### LiveView Composition

LiveNest provides a suite of macros for structuring your LiveViews:

```elixir
# For primary routed LiveViews
use Phoenix.LiveView
use LiveNest, :routed_live_view

# For nested LiveViews
use Phoenix.LiveView
use LiveNest, :embedded_live_view

# For modal LiveViews
use Phoenix.LiveView
use LiveNest, :modal_live_view

# For modal LiveComponents
use Phoenix.LiveComponent
use LiveNest, :modal_live_component
```

### LiveView Nesting

Implement nested LiveViews with session-based configuration:

```elixir
# Utilize Phoenix's live_render with session parameters
{live_render(@socket, MyApp.MyLiveView, id: "my-live-view", session: [key1: "value1", key2: "value2"])}

# Implement mount callback in the nested LiveView
def mount(:not_mounted_at_router, %{"key1" => "value1", "key2" => "value2"}, socket)
```

### Event Management

Implement controlled event propagation through the LiveView hierarchy:

```elixir
# Emit events within the LiveView hierarchy
publish_event(socket, "user_updated", %{user_id: 123})

# Handle events with controlled propagation
def consume_event(%{name: "user_updated", payload: %{user_id: user_id}}, socket) do
  # Process the event and continue propagation
  {:continue, socket}
end

# Handle events and terminate propagation
def consume_event(%{name: "user_updated", payload: %{user_id: user_id}}, socket) do
  # Process the event and stop propagation
  {:stop, socket}
end
```

### Modal Implementation

LiveNest offers a comprehensive modal system supporting both LiveView and LiveComponent implementations:

```elixir
# Configure LiveView modal
LiveNest.Modal.prepare_live_view("my-live-view-modal", MyLiveViewModal)

# Configure LiveComponent modal
LiveNest.Modal.prepare_live_component("my-live-component-modal", MyLiveComponentModal)

# Present modal within the LiveView hierarchy
present_modal(socket, LiveNest.Modal.prepare_live_view("my-modal-live-view", MyModalLiveView))

# Handle modal closure events
def consume_event(%{name: @close_modal_event, payload: %{modal_id: "my-modal-live-view"}}, socket) do
  {:noreply, close_modal(socket)}
end
```

## A note on: LiveComponents

LiveNest follows Phoenix's architectural principles, which dictate that LiveComponents should only be nested within LiveViews, not within other LiveComponents. This design decision is intentional and serves several important purposes:

1. **State Management**: LiveComponents are designed to manage their own state independently. Nesting them within other LiveComponents could lead to complex state management issues and potential race conditions.

2. **Event Propagation**: The event system is optimized for a clear hierarchy where LiveComponents communicate with their parent LiveView. Nested LiveComponents would complicate the event propagation model.

For complex nested structures, LiveNest provides a robust LiveView composition system as an alternative to nested LiveComponents.

## Documentation

For comprehensive documentation on LiveNest's architecture and features, please refer to the [official documentation](https://hexdocs.pm/live_nest).

## Contributing

We welcome contributions to LiveNest. Please submit a Pull Request for minor changes. For significant modifications, please initiate a discussion by opening an issue first.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.