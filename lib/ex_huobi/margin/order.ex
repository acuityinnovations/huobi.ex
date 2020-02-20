defmodule ExHuobi.Margin.Order do
  defstruct ~w(
    id
    symbol
    account-id
    amount
    price
    created-at
    type
    field-amount
    field-cash-amount
    field-fees
    finished-at
    user-id
    source
    state
    canceled-at
  )a
end
