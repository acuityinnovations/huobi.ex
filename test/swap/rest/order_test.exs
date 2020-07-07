defmodule ExHuobi.Swap.Rest.Order.Test do
  use ExUnit.Case, async: true

  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias ExHuobi.Swap.Rest.Order, as: OrderApi

  setup_all do
    HTTPoison.start()

    %{config: nil}
  end

  test "create order success", %{config: config} do
    use_cassette("/swap/order/create_order_success") do
      order = %{
        "direction" => "Buy",
        "lever_rate" => 5,
        "offset" => "open",
        "order_price_type" => "limit",
        "price" => 5000,
        "contract_code" => "BTC-USD",
        "client_order_id" => 92_233_720_361,
        "volume" => 1
      }

      assert OrderApi.create_order(order, config) ==
               {:ok,
                %{
                  "order_id_str" => "729685378616885248",
                  "client_order_id" => 92_233_720_361,
                  "order_id" => 729_685_378_616_885_248
                }}
    end
  end

  test "create order bulk", %{config: config} do
    use_cassette("/swap/order/create_bulk_orders_success") do
      order = %{
        "orders_data" => [
          %{
            "direction" => "Buy",
            "lever_rate" => 5,
            "offset" => "open",
            "order_price_type" => "limit",
            "price" => 9000,
            "contract_code" => "BTC-USD",
            "client_order_id" => 92_233_720_362,
            "volume" => 1
          },
          %{
            "direction" => "Sell",
            "lever_rate" => 5,
            "offset" => "open",
            "order_price_type" => "limit",
            "price" => 9600,
            "contract_code" => "BTC-USD",
            "client_order_id" => 92_233_720_364,
            "volume" => 1
          }
        ]
      }

      assert OrderApi.create_bulk_orders(order, config) ==
               {:ok,
                %{
                  "errors" => [],
                  "success" => [
                    %{
                      "client_order_id" => 92_233_720_362,
                      "index" => 1,
                      "order_id" => 729_816_536_205_795_328,
                      "order_id_str" => "729816536205795328"
                    },
                    %{
                      "client_order_id" => 92_233_720_364,
                      "index" => 2,
                      "order_id" => 729_816_536_230_961_152,
                      "order_id_str" => "729816536230961152"
                    }
                  ]
                }}
    end
  end
end
