defmodule ExHuobi.Futures.Rest.Order do
  @moduledoc false

  alias ExHuobi.Futures.Rest.Handler
  alias ExHuobi.Rest.HTTPClient

  @type params :: map
  @type config :: map

  @hbdm_host "https://api.hbdm.com"

  # @doc """
  # Place order in the huobi futures exchanges

  # https://huobiapi.github.io/docs/dm/v1/en/#place-an-order

  # ## Examples

  # iex> ExHuobi.Futures.Rest.Order.create_order(
  #   %{ symbol: "BTC",
  #     contract_type: "this_week",
  #     volume: 1,
  #     price: 5000,
  #     direction: "Buy",
  #     lever_rate: 5,
  #     offset: "open",
  #     order_price_type: "limit"
  #   })
  # """
  @spec create_order(map, config) :: {:ok, map} | {:error, any}
  def create_order(order, config) do
    @hbdm_host
    |> HTTPClient.post("/api/v1/contract_order", order, config)
    |> Handler.parse_response()
  end

  # @doc """
  # Place order in the huobi futures exchanges

  # https://huobiapi.github.io/docs/dm/v1/en/#place-a-batch-of-orders

  # ## Examples

  # iex> ExHuobi.Futures.Rest.Order.create_bulk_orders(%{"orders_data" => [
  #   { symbol: "BTC",
  #     contract_type: "this_week",
  #     volume: 1,
  #     price: 5000,
  #     direction: "Buy",
  #     lever_rate: 5,
  #     offset: "open",
  #     order_price_type: "limit"
  #   },
  #   { symbol: "BTC",
  #     contract_type: "this_week",
  #     volume: 1,
  #     price: 5000,
  #     direction: "Buy",
  #     lever_rate: 5,
  #     offset: "open",
  #     order_price_type: "limit"
  #   }
  # ])
  # """
  @spec create_bulk_orders(map, config) :: {:ok, list} | {:error, any}
  def create_bulk_orders(orders, config) do
    @hbdm_host
    |> HTTPClient.post("/api/v1/contract_batchorder", orders, config)
    |> Handler.parse_response()
  end

  # @doc """
  # Cancel on order in huobi future exchanges using order id

  # https://huobiapi.github.io/docs/dm/v1/en/#cancel-an-order

  # ## Examples

  # iex> ExHuobi.Futures.Rest.Order.cancel_order(%{
  #   "order_id => "1234",
  #   "symbol" => "BTC"
  # }, config)
  # """
  @spec cancel_order(map, config) :: {:ok, any} | {:error, any}
  def cancel_order(order, config) do
    @hbdm_host
    |> HTTPClient.post("/api/v1/contract_cancel", order, config)
    |> Handler.parse_response()
  end
end
