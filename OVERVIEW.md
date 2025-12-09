
# LiveNest Technical Overview

## Architecture

LiveNest is built on top of Phoenix LiveView and provides a structured approach to building complex web applications. The framework is organized around several core concepts:

### Core Components

1. **LiveView Composition**
   - Hierarchical structure for organizing LiveViews
   - Support for both routed and embedded LiveViews
   - Session-based configuration for embedded LiveViews

2. **Event System**
   - Structured event propagation through the LiveView hierarchy
   - Type-safe event definitions
   - Controlled event bubbling with continue/stop semantics
   - Source tracking for event origin

3. **Modal System**
   - Support for both LiveView and LiveComponent modals
   - Modal controller pattern for managing modal state
   - Automatic PID tracking for modal communication
   - Mount hooks for modal initialization

4. **HTML Utilities**
   - Enhanced HTML helpers for common patterns
   - Type-safe constant definitions
   - Consistent element structure

## Technical Implementation

### Modal System

The modal system is implemented through the `LiveNest.Modal` module, which provides:

```elixir
# Type definitions
@type id :: atom() | binary()
@type style :: atom()
@type visible :: boolean()
@type controller_pid :: pid()
@type element :: LiveNest.Element.t()
@type t :: %__MODULE__{style: style, visible: visible, controller_pid: controller_pid, element: element()}

# Preparation functions
def prepare_live_view(id, module, options \\ [])
def prepare_live_component(id, module, options \\ [])

# Mount hooks
def on_mount(:initialize, _params, session, socket)
```

### Event System

Events are implemented through the `LiveNest.Event` module with the following structure:

```elixir
@type source :: pid()
@type payload :: map() | nil
@type name :: atom()

@type t :: %__MODULE__{
  name: name(),
  source: source(),
  payload: payload()
}
```

### LiveView Composition

LiveNest provides several macros for structuring LiveViews:

```elixir
# Routed LiveView
use Phoenix.LiveView
use LiveNest, :routed_live_view

# Embedded LiveView
use Phoenix.LiveView
use LiveNest, :embedded_live_view

# Modal LiveView
use Phoenix.LiveView
use LiveNest, :modal_live_view

# Modal LiveComponent
use Phoenix.LiveComponent
use LiveNest, :modal_live_component
```

## Design Principles

1. **Hierarchical Structure**
   - Clear parent-child relationships
   - Controlled event propagation
   - State isolation between components

2. **Type Safety**
   - Comprehensive type definitions
   - Runtime type checking
   - Clear interface boundaries

3. **Modularity**
   - Independent component lifecycle
   - Clear separation of concerns
   - Reusable patterns

4. **Event-Driven Architecture**
   - Unidirectional data flow
   - Controlled event bubbling
   - Source tracking for debugging

## Best Practices

1. **LiveView Composition**
   - Use session parameters for configuration
   - Implement proper mount callbacks
   - Handle state updates appropriately

2. **Modal Management**
   - Use appropriate modal type (LiveView vs LiveComponent)
   - Handle modal lifecycle events
   - Implement proper cleanup

3. **Event Handling**
   - Use type-safe event definitions
   - Implement proper event propagation control
   - Handle event source tracking

4. **Component Structure**
   - Follow Phoenix's LiveComponent guidelines
   - Maintain clear component boundaries
   - Use appropriate state management

