defmodule ExHuobi.Futures.Rest.Account.Test do
  use ExUnit.Case, async: true

  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    System.put_env("HUOBI_API_KEY", "12343")
    System.put_env("HUOBI_API_SECRET", "12345")
    HTTPoison.start()
  end

  test "create order success" do
    use_cassette("/futures/order/create_order_success") do
      order = %{
        "contract_type" => "this_week",
        "direction" => "Buy",
        "lever_rate" => 5,
        "offset" => "open",
        "order_price_type" => "limit",
        "price" => 5000,
        "symbol" => "BTC",
        "volume" => 1
      }

      assert ExHuobi.Futures.Rest.Order.create_order(order, nil) ==
               {:ok, %{"order_id" => 680_494_320_326_811_648, "order_id_str" => "680494320326811648"}}
    end
  end

  test "create order verification error" do
    use_cassette("/futures/order/create_order_invalid_key_error") do
      order = %{
        "contract_type" => "this_week",
        "direction" => "Buy",
        "lever_rate" => 5,
        "offset" => "open",
        "order_price_type" => "limit",
        "price" => 5000,
        "symbol" => "BTC",
        "volume" => 1
      }
      assert ExHuobi.Futures.Rest.Order.create_order(order, nil) == nil
    end
  end

  # test "create order abnormal service" do
  #   use_cassette("httpoison_create_order") do
  #     order = nil
  #     assert ExHuobi.Futures.Rest.Order.create_order(order, nil)
  #   end
  # end
end
