defmodule LiveNest.Event do
  @moduledoc """
  This module defines the Event struct, which serves as a mechanism for event propagation in LiveNest.
  """

  @type source :: pid()
  @type payload :: any()
  @type name :: atom()

  @type t :: %__MODULE__{
          name: name(),
          source: source(),
          payload: payload()
        }

  defstruct [:name, :source, :payload]
end
