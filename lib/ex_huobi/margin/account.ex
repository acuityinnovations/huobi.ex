defmodule ExHuobi.Margin.Account do
  @moduledoc false

  @type t :: %__MODULE__{}

  defstruct ~w(
    id
    state
    type
    subtype
  )a
end
