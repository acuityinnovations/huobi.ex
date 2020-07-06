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
end
