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

  test "remove order success", %{config: config} do
    use_cassette("/swap/order/remove_order_success") do
      order = %{
        contract_code: "BTC-USD",
        client_order_id: "92233720368534"
      }

      assert OrderApi.remove_order(order, config) ==
               {:ok, %{"errors" => [], "successes" => "92233720368534"}}
    end
  end

  test "remove all open orders success", %{config: config} do
    use_cassette("/swap/order/remove_all_open_orders_success") do
      assert OrderApi.cancel_all_orders(%{contract_code: "BTC-USD"}, config) ==
               {:error, %{"err_code" => 1051, "err_msg" => "No orders to cancel.", "status" => "error", "ts" => 1612361834309}}
    end
  end

  test "remove order failure", %{config: config} do
    use_cassette("/swap/order/remove_order_fail") do
      order = %{
        contract_code: "BTC-USD",
        client_order_id: "92233720368534"
      }

      assert OrderApi.remove_order(order, config) ==
               {:ok,
                %{
                  "errors" => [
                    %{
                      "err_code" => 1071,
                      "err_msg" => "Repeated withdraw.",
                      "order_id" => "92233720368534"
                    }
                  ],
                  "successes" => ""
                }}
    end
  end

  test "remove non exist order", %{config: config} do
    use_cassette("/swap/order/remove_non_exits_order") do
      order = %{
        contract_code: "BTC-USD",
        client_order_id: "9223372036853411"
      }

      assert OrderApi.remove_order(order, config) ==
               {:ok,
                %{
                  "successes" => "",
                  "errors" => [
                    %{
                      "err_code" => 1061,
                      "err_msg" => "This order doesnt exist.",
                      "order_id" => "9223372036853411"
                    }
                  ]
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

  test "get open orders", %{config: config} do
    use_cassette("/swap/order/get_open_orders") do
      assert OrderApi.get_open_orders("BTC-USD", config) ==
               {:ok,
                %{
                  "current_page" => 1,
                  "orders" => [
                    %{
                      "canceled_at" => nil,
                      "client_order_id" => 92_233_720_368_512,
                      "contract_code" => "BTC-USD",
                      "created_at" => 1_606_626_246_006,
                      "direction" => "buy",
                      "fee" => 0,
                      "fee_asset" => "BTC",
                      "lever_rate" => 5,
                      "liquidation_type" => nil,
                      "margin_frozen" => 0.001333333333333333,
                      "offset" => "open",
                      "order_id" => 782_592_727_086_178_305,
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
    end
  end
end
