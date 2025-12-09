defmodule LiveNest.Event do
  @moduledoc """
  This module defines the Event struct, which serves as a mechanism for event propagation in LiveNest.
  """

  @type source :: {pid(), any()} | nil
  @type payload :: map() | nil
  @type name :: atom()

  @type t :: %__MODULE__{
          name: name(),
          source: source(),
          payload: payload()
        }

  defstruct [:name, :source, :payload]
end
