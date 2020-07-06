defmodule ExHuobi.Futures.AccountInfo do
  @moduledoc false

  @type t :: %__MODULE__{}

  defstruct ~w(
    adjust_factor
    is_debit
    lever_rate
    liquidation_price
    margin_available
    margin_balance
    margin_frozen
    margin_position
    margin_static
    profit_real
    profit_unreal
    risk_rate
    symbol
    withdraw_available
  )a
end
