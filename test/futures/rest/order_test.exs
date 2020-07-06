defmodule ExHuobi.Futures.Rest.Order.Test do
  use ExUnit.Case, async: true

  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias ExHuobi.Futures.Rest.Order, as: OrderApi

  setup_all do
    HTTPoison.start()

    %{config: nil}
  end

  test "create order success", %{config: config} do
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

      assert OrderApi.create_order(order, config) ==
               {:ok,
                %{"order_id" => 680_494_320_326_811_648, "order_id_str" => "680494320326811648"}}
    end
  end

  test "create order invalid key error", %{config: config} do
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

      {:error,
       %{
         "err_code" => error_code,
         "err_msg" => err_msg,
         "status" => status
       }} = OrderApi.create_order(order, config)

      assert error_code == 403
      assert String.starts_with?(err_msg, "Incorrect Access key") == true
      assert status == "error"
    end
  end

  test "create order verification error", %{config: config} do
    use_cassette("/futures/order/create_order_vf_error") do
      order = nil

      {:error,
       %{
         "err_code" => error_code,
         "err_msg" => err_msg,
         "status" => status
       }} = OrderApi.create_order(order, config)

      assert error_code == 403
      assert String.starts_with?(err_msg, "Verification failure") == true
      assert status == "error"
    end
  end

  test "create order abnormal service error", %{config: config} do
    use_cassette("/futures/order/create_order_abnormal_service_error") do
      order = nil

      {:error,
       %{
         "err_code" => error_code,
         "err_msg" => err_msg,
         "status" => status
       }} = OrderApi.create_order(order, config)

      assert error_code == 1030
      assert String.starts_with?(err_msg, "Abnormal service.") == true
      assert status == "error"
    end
  end

  test "create order insufficient margin error", %{config: config} do
    use_cassette("/futures/order/create_order_insufficient_margin_error") do
      order = nil

      {:error,
       %{
         "err_code" => error_code,
         "err_msg" => err_msg,
         "status" => status
       }} = OrderApi.create_order(order, config)

      assert error_code == 1047
      assert String.starts_with?(err_msg, "Insufficient margin available.") == true
      assert status == "error"
    end
  end
end
