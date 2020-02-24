defmodule ExHuobi.Futures.Private do
  alias ExHuobi.Rest.HTTPClient

  @hbdm_host "api.hbdm.com"

  @doc """
  Place order in the huobi futures exchanges

  https://huobiapi.github.io/docs/dm/v1/en/#place-an-order

  ## Examples

  iex> ExHuobi.Futures.Private.create_order(
    { symbol: "BTC",
      contract_type: "this_week",
      volume: 1,
      price: 5000,
      direction: "Buy",
      lever_rate: 5,
      offset: "open",
      order_price_type: "limit"
    })
  """
  def create_order(order, config \\ nil) do
    HTTPClient.post(@hbdm_host, "/api/v1/contract_order", order, config)
  end

  @doc """
  Place order in the huobi futures exchanges

  https://huobiapi.github.io/docs/dm/v1/en/#place-a-batch-of-orders

  ## Examples

  iex> ExHuobi.Futures.Private.create_bulk_orders([
    { symbol: "BTC",
      contract_type: "this_week",
      volume: 1,
      price: 5000,
      direction: "Buy",
      lever_rate: 5,
      offset: "open",
      order_price_type: "limit"
    },
    { symbol: "BTC",
      contract_type: "this_week",
      volume: 1,
      price: 5000,
      direction: "Buy",
      lever_rate: 5,
      offset: "open",
      order_price_type: "limit"
    }
  ])
  """
  def create_bulk_orders(orders, config \\ nil) do
    HTTPClient.post(@hbdm_host, "/api/v1/contract_order", orders, config)
  end

  @doc """
  Cancel on order in huobi future exchanges using order id

  https://huobiapi.github.io/docs/dm/v1/en/#cancel-an-order

  ## Examples

  iex> ExHuobi.Futures.Private.cancel_order({
    "order_id : "1234",
    "symbol": "BTC"
  })
  """
  def cancel_order(order, config \\ nil) do
    HTTPClient.post(@hbdm_host, "/api/v1/contract_cancel", order, config)
  end

  @doc """
  Get user position in huobi exchange

  https://huobiapi.github.io/docs/dm/v1/en/#user-s-position-information

  ## Examples

  iex> ExHuobi.Futures.Private.get_position("BTC")
  """
  def get_position(instrument_id, config \\ nil) do
    HTTPClient.post(
      @hbdm_host,
      "/api/v1/contract_position_info",
      %{"symbol" => instrument_id},
      config
    )
  end
end
