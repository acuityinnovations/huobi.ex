defmodule ExHuobi.Swap.Rest.Order do
  @moduledoc false

  alias ExHuobi.Rest.HTTPClient
  alias ExHuobi.Swap.Rest.Handler

  @type params :: map
  @type config :: map

  @hbdm_host "https://api.hbdm.com"

  # @doc """
  # Place order in the huobi swap exchanges

  # https://huobiapi.github.io/docs/coin_margined_swap/v1/en/#place-an-order

  # ## Examples

  # iex> ExHuobi.Swap.Rest.Order.create_order(
  #   %{ contract_code: "BTC-USD",
  #     client_order_id: 922337203685,
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
    |> HTTPClient.post("/swap-api/v1/swap_order", order, config)
    |> Handler.parse_response()
  end

  # ExHuobi.Swap.Rest.Order.create_bulk_orders(%{"orders_data" => [
  # %{ contract_code: "BTC-USD",
  #   client_order_id: "9223372031",
  #   volume: 1,
  #   price: 9000,
  #   direction: "Buy",
  #   lever_rate: 5,
  #   offset: "open",
  #   order_price_type: "limit"
  # },
  # %{ contract_code: "BTC-USD",
  #   client_order_id: "9223372032",
  #   volume: 1,
  #   price: 9600,
  #   direction: "Sell",
  #   lever_rate: 5,
  #   offset: "open",
  #   order_price_type: "limit"
  # }]}, nil)
  #
  # Response
  # {:ok,
  #  %{
  #    "errors" => [],
  #    "success" => [
  #      %{
  #        "client_order_id" => 9223372031,
  #        "index" => 1,
  #        "order_id" => 729814979552854016,
  #        "order_id_str" => "729814979552854016"
  #      },
  #      %{
  #        "client_order_id" => 9223372032,
  #        "index" => 2,
  #        "order_id" => 729814979582214144,
  #        "order_id_str" => "729814979582214144"
  #      }
  #    ]
  #  }}
  def create_bulk_orders(order, config) do
    @hbdm_host
    |> HTTPClient.post("/swap-api/v1/swap_batchorder", order, config)
    |> Handler.parse_response()
  end
end
