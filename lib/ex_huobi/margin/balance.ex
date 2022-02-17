defmodule ExHuobi.Margin.Balance do
  @moduledoc false

  @type t :: %__MODULE__{}

  defstruct ~w(
    id
    state
    type
    list
  )a
end
