defmodule ExHuobi.Rest.Orders.CreateTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias ExHuobi.Margin.Rest.Order, as: Rest

  setup_all do
    HTTPoison.start()
    :ok
  end

  @config %ExHuobi.Config{
    api_key: System.get_env("HUOBI_API_KEY"),
    api_secret: System.get_env("HUOBI_API_SECRET")
  }

  test "create order" do
    use_cassette "rest/orders/create", custom: true do
      return_id = "70646394808"

      params = %{
        "account-id": 123_456_789,
        amount: 0.0001,
        price: 11000,
        symbol: "btcusdt",
        type: "sell-limit",
        source: "super-margin-api"
      }

      {:ok, order} = Rest.create(params, @config)
      assert return_id == order.id
    end
  end

  test "create order batch" do
    use_cassette "rest/orders/bulk_create", custom: true do
      params = [
        %{
          "account-id": 123_456_789,
          amount: 0.0001,
          price: 11000,
          symbol: "btcusdt",
          type: "sell-limit",
          source: "super-margin-api"
        },
        %{
          "account-id": 123_456_789,
          amount: 0.0001,
          price: 11000,
          symbol: "btcusdt",
          type: "sell-limit",
          source: "super-margin-api"
        }
      ]

      {:ok, orders} = Rest.bulk_create(params, @config)
      assert length(orders) == 2
    end
  end
end
