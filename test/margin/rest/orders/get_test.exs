defmodule ExHuobi.Rest.Orders.GetTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias ExHuobi.Margin.Order
  alias ExHuobi.Margin.Rest.Order, as: Rest

  setup_all do
    HTTPoison.start()
    :ok
  end

  @config %ExHuobi.Config{
    api_key: System.get_env("HUOBI_API_KEY"),
    api_secret: System.get_env("HUOBI_API_SECRET")
  }

  test "returns order by id" do
    use_cassette "rest/orders/get_by_id", custom: true do
      input_id = 70_646_394_808
      {:ok, %Order{id: id}} = Rest.get(70_646_394_808, @config)

      assert input_id == id
    end
  end

  test "returns all open orders" do
    use_cassette "rest/orders/get_all_open", custom: true do
      assert {:ok, [%Order{}]} =
               Rest.get_open(%{"account-id": 123_456_789, symbol: "btcusdt"}, @config)
    end
  end
end
