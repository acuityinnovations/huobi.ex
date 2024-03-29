defmodule ExHuobi.UsdtSwap.Rest.Order do
  @moduledoc false

  alias ExHuobi.Rest.HTTPClient
  alias ExHuobi.UsdtSwap.Rest.Handler

  @type params :: map
  @type config :: map

  @hbdm_host "https://api.hbdm.com"

  @doc """
  Place order in the huobi swap exchanges

  https://huobiapi.github.io/docs/usdt_swap/v1/en/#cross-place-an-order

  Examples

  ExHuobi.UsdtSwap.Rest.Order.create_cross_order(
   %{contract_code: "BTC-USDT",
     client_order_id: 912337313611,
     volume: 1,
     price: 1000,
     direction: "Buy",
     lever_rate: 5,
     offset: "open",
     order_price_type: "fok"
    }, nil)

  {:ok,
   %{
     "client_order_id" => 922337203685,
     "order_id" => 782591375958564865,
     "order_id_str" => "782591375958564865"
   }}
  """
  @spec create_cross_order(map, config) :: {:ok, map} | {:error, any}
  def create_cross_order(order, config) do
    @hbdm_host
    |> HTTPClient.post("/linear-swap-api/v1/swap_cross_order", order, config)
    |> Handler.parse_response()
  end

  @doc """
  Place multiple orders in the huobi swap exchanges
  Examples:

  ExHuobi.UsdtSwap.Rest.Order.create_bulk_cross_orders(%{"orders_data" => [
   %{ contract_code: "BTC-USDT",
     client_order_id: "9223372031",
     volume: 1,
     price: 9000,
     direction: "Buy",
     lever_rate: 5,
     offset: "open",
     order_price_type: "limit"
   },
   %{ contract_code: "BTC-USDT",
     client_order_id: "9223372032",
     volume: 1,
     price: 9600,
     direction: "Sell",
     lever_rate: 5,
     offset: "open",
    order_price_type: "limit"
   }]}, nil)

   {:ok,
    %{
      "errors" => [],
      "success" => [
        %{
          "client_order_id" => 9223372031,
          "index" => 1,
          "order_id" => 729814979552854016,
          "order_id_str" => "729814979552854016"
        },
        %{
          "client_order_id" => 9223372032,
          "index" => 2,
          "order_id" => 729814979582214144,
          "order_id_str" => "729814979582214144"
        }
      ]
    }}
  """
  def create_bulk_cross_orders(order, config) do
    @hbdm_host
    |> HTTPClient.post("/linear-swap-api/v1/swap_cross_batchorder", order, config)
    |> Handler.parse_response()
  end

  @doc """
  remove an order
  Examples:
  ExHuobi.UsdtSwap.Rest.Order.remove_cross_order(%{contract_code: "BTC-USDT", client_order_id: 922337203611}, nil)

  {:ok, %{"errors" => [], "successes" => "922337203611"}}
  """
  def remove_cross_order(order, config) do
    @hbdm_host
    |> HTTPClient.post("/linear-swap-api/v1/swap_cross_cancel", order, config)
    |> Handler.parse_response()
  end

  @doc """
  remove all open orders
  Examples:
  ExHuobi.UsdtSwap.Rest.cancel_all_cross_orders(%{contract_code: "BTC-USDT"}, nil)
  """
  def cancel_all_cross_orders(params, config) do
    @hbdm_host
    |> HTTPClient.post("/linear-swap-api/v1/swap_cross_cancelall", params, config)
    |> Handler.parse_response()
  end

  @doc """
  ExHuobi.UsdtSwap.Rest.Order.get_open_cross_orders("BTC-USDT", nil)

  {:ok,
   %{
     "current_page" => 1,
     "orders" => [
       %{
         "canceled_at" => nil,
         "client_order_id" => 92233720368512,
         "contract_code" => "BTC-USDT",
         "created_at" => 1606626246006,
         "direction" => "buy",
         "fee" => 0,
         "fee_asset" => "BTC",
         "lever_rate" => 5,
         "liquidation_type" => nil,
         "margin_frozen" => 0.001333333333333333,
         "offset" => "open",
         "order_id" => 782592727086178305,
         "order_id_str" => "782592727086178305",
         "order_price_type" => "limit",
         "order_source" => "api",
         "order_type" => 1,
         "price" => 15000,
         "profit" => 0,
         "status" => 3,
         "symbol" => "BTC",
         "trade_avg_price" => nil,
         "trade_turnover" => 0,
         "trade_volume" => 0,
         "volume" => 1
       }
     ],
     "total_page" => 1,
     "total_size" => 1
   }}
  """
  def get_open_cross_orders(contract_code, config) do
    payload = %{contract_code: contract_code, page_size: 50}

    @hbdm_host
    |> HTTPClient.post("/linear-swap-api/v1/swap_cross_openorders", payload, config)
    |> Handler.parse_response()
  end
end
