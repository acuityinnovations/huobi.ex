defmodule ExHuobi.UsdtSwap.Rest.Order.Test do
  use ExUnit.Case, async: true

  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias ExHuobi.UsdtSwap.Rest.Order, as: OrderApi

  setup_all do
    HTTPoison.start()

    %{config: nil}
  end

  test "create cross order success", %{config: config} do
    use_cassette("/usdt_swap/order/create_cross_order_success") do
      order = %{
        "direction" => "Buy",
        "lever_rate" => 5,
        "offset" => "open",
        "order_price_type" => "limit",
        "price" => 37200,
        "contract_code" => "BTC-USDT",
        "client_order_id" => 92_233_720_361,
        "volume" => 1
      }

      assert OrderApi.create_cross_order(order, config) ==
               {:ok,
                %{
                  "client_order_id" => 92_233_720_361,
                  "order_id" => 796_793_997_598_580_736,
                  "order_id_str" => "796793997598580736"
                }}
    end
  end

  test "remove cross order success", %{config: config} do
    use_cassette("/usdt_swap/order/remove_cross_order_success") do
      order = %{
        contract_code: "BTC-USDT",
        client_order_id: "11223345"
      }

      assert OrderApi.remove_cross_order(order, config) ==
               {:ok, %{"errors" => [], "successes" => "11223345"}}
    end
  end

  test "remove non exist cross order", %{config: config} do
    use_cassette("/usdt_swap/order/remove_non_exits_cross_order") do
      order = %{
        contract_code: "BTC-USDT",
        client_order_id: "9223372036853411"
      }

      assert OrderApi.remove_cross_order(order, config) ==
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

  test "create cross order bulk", %{config: config} do
    use_cassette("/usdt_swap/order/create_bulk_cross_orders_success") do
      order = %{
        "orders_data" => [
          %{
            "direction" => "Buy",
            "lever_rate" => 5,
            "offset" => "open",
            "order_price_type" => "limit",
            "price" => 29000,
            "contract_code" => "BTC-USDT",
            "client_order_id" => 92_233_720_368,
            "volume" => 1
          },
          %{
            "direction" => "Sell",
            "lever_rate" => 5,
            "offset" => "open",
            "order_price_type" => "limit",
            "price" => 38000,
            "contract_code" => "BTC-USDT",
            "client_order_id" => 92_233_720_369,
            "volume" => 1
          }
        ]
      }

      assert OrderApi.create_bulk_cross_orders(order, config) ==
               {:ok,
                %{
                  "errors" => [],
                  "success" => [
                    %{
                      "index" => 1,
                      "client_order_id" => 92_233_720_368,
                      "order_id" => 796_801_153_878_130_688,
                      "order_id_str" => "796801153878130688"
                    },
                    %{
                      "index" => 2,
                      "client_order_id" => 92_233_720_369,
                      "order_id" => 796_801_153_894_907_904,
                      "order_id_str" => "796801153894907904"
                    }
                  ]
                }}
    end
  end

  test "get open cross orders", %{config: config} do
    use_cassette("/usdt_swap/order/get_open_cross_orders") do
      assert OrderApi.get_open_cross_orders("BTC-USDT", config) ==
               {:ok,
                %{
                  "current_page" => 1,
                  "total_page" => 1,
                  "orders" => [
                    %{
                      "canceled_at" => nil,
                      "fee" => 0,
                      "lever_rate" => 5,
                      "liquidation_type" => nil,
                      "offset" => "open",
                      "order_price_type" => "limit",
                      "order_source" => "api",
                      "order_type" => 1,
                      "profit" => 0,
                      "status" => 3,
                      "symbol" => "BTC",
                      "trade_avg_price" => nil,
                      "trade_turnover" => 0,
                      "trade_volume" => 0,
                      "volume" => 1,
                      "client_order_id" => 92_233_720_369,
                      "contract_code" => "BTC-USDT",
                      "created_at" => 1_610_013_798_935,
                      "direction" => "sell",
                      "fee_asset" => "USDT",
                      "margin_frozen" => 7.6,
                      "order_id" => 796_801_153_894_907_904,
                      "order_id_str" => "796801153894907904",
                      "price" => 38000,
                      "margin_account" => "USDT",
                      "margin_asset" => "USDT",
                      "margin_mode" => "cross"
                    },
                    %{
                      "canceled_at" => nil,
                      "client_order_id" => 92_233_720_368,
                      "contract_code" => "BTC-USDT",
                      "created_at" => 1_610_013_798_931,
                      "direction" => "buy",
                      "fee" => 0,
                      "fee_asset" => "USDT",
                      "lever_rate" => 5,
                      "liquidation_type" => nil,
                      "margin_account" => "USDT",
                      "margin_asset" => "USDT",
                      "margin_frozen" => 5.8,
                      "margin_mode" => "cross",
                      "offset" => "open",
                      "order_id" => 796_801_153_878_130_688,
                      "order_id_str" => "796801153878130688",
                      "order_price_type" => "limit",
                      "order_source" => "api",
                      "order_type" => 1,
                      "price" => 29000,
                      "profit" => 0,
                      "status" => 3,
                      "symbol" => "BTC",
                      "trade_avg_price" => nil,
                      "trade_turnover" => 0,
                      "trade_volume" => 0,
                      "volume" => 1
                    }
                  ],
                  "total_size" => 2
                }}
    end
  end

  test "remove all cross order success", %{config: config} do
    use_cassette("/usdt_swap/order/cancel_all_cross_orders") do
      order = %{
        contract_code: "BTC-USDT"
      }

      assert OrderApi.cancel_all_cross_orders(order, config) ==
               {:ok, %{"errors" => [], "successes" => "870285458012192768"}}
    end
  end
end
