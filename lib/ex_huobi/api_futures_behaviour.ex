defmodule ExHuobi.ApiFutruresBehaviour do
  @callback create_order(map, map) :: {:ok, map} | {:error, any}
  @callback create_bulk_orders(map, map) :: {:ok, list} | {:error, any}
  @callback cancel_order(map, map) :: {:ok, any} | {:error, any}
end
