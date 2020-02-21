defmodule ExHuobi.Futures.Rest.Order do
  alias ExHuobi.Rest.HTTPClient

  @type params :: map
  @type config :: ExHuobi.Config.t()

  @hbdm_host "https://api.hbdm.com"

  # @doc """
  # Place order in the huobi futures exchanges

  # https://huobiapi.github.io/docs/dm/v1/en/#place-an-order

  # ## Examples

  # iex> ExHuobi.Futures.Private.create_order(
  #   { symbol: "BTC",
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
  def create_order(order, config \\ nil) do
    HTTPClient.post(@hbdm_host, "/api/v1/contract_order", order, config)
    |> IO.inspect()
    |> ExHuobi.Futures.Util.parse_response()
  end

  # @doc """
  # Place order in the huobi futures exchanges

  # https://huobiapi.github.io/docs/dm/v1/en/#place-a-batch-of-orders

  # ## Examples

  # iex> ExHuobi.Futures.Private.create_bulk_orders([
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
  @spec create_bulk_orders(list(map), config) :: {:ok, list} | {:error, any}
  def create_bulk_orders(orders, config \\ nil) do
    HTTPClient.post(@hbdm_host, "/api/v1/contract_order", orders, config)
    |> IO.inspect()
    |> ExHuobi.Futures.Util.parse_response()
  end

  # @doc """
  # Cancel on order in huobi future exchanges using order id

  # https://huobiapi.github.io/docs/dm/v1/en/#cancel-an-order

  # ## Examples

  # iex> ExHuobi.Futures.Private.cancel_order({
  #   "order_id : "1234",
  #   "symbol": "BTC"
  # })
  # """
  @spec cancel_order(map, config) :: {:ok, any} | {:error, any}
  def cancel_order(order, config \\ nil) do
    HTTPClient.post(@hbdm_host, "/api/v1/contract_cancel", order, config)
    |> IO.inspect()
    |> ExHuobi.Futures.Util.parse_response()
  end
end
