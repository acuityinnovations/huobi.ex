defmodule ExHuobi.Margin.Account do
  @type t :: %__MODULE__{}

  defstruct ~w(
    id
    state
    type
    subtype
  )a
end
