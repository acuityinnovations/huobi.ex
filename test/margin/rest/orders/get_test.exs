defmodule ExHuobi.Rest.Orders.GetTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias ExHuobi.Margin.Order
  alias ExHuobi.Margin.Rest.Order, as: Rest

  setup_all do
    HTTPoison.start()

    %{
      config: %ExHuobi.Config{
        api_key: "12345",
        api_secret: "12345"
      }
    }
  end

  test "returns order by id", %{config: config} do
    use_cassette "rest/orders/get_by_id", custom: true do
      input_id = 70_646_394_808
      {:ok, %Order{id: id}} = Rest.get(70_646_394_808, config)

      assert input_id == id
    end
  end

  test "returns all open orders", %{config: config} do
    use_cassette "rest/orders/get_all_open", custom: true do
      assert {:ok, [%Order{}]} =
               Rest.get_open(%{"account-id": 123_456_789, symbol: "btcusdt"}, config)
    end
  end
end
