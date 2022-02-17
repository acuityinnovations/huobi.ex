defmodule ExHuobi.Futures.Position do
  @moduledoc false

  @type t :: %__MODULE__{}

  defstruct ~w(
    symbol
    contract_code
    contract_type
    volume
    available
    frozen
    cost_open
    cost_hold
    profit_unreal
    profit_rate
    lever_rate
    position_margin
    direction
    profit
    last_price
  )a
end
