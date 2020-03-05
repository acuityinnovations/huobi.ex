defmodule ExHuobi.Rest.Orders.CreateTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

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

  test "create order", %{config: config} do
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

      {:ok, order} = Rest.create(params, config)
      assert order == return_id
    end
  end

  test "create order batch", %{config: config} do
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

      {:ok, orders} = Rest.bulk_create(params, config)
      assert length(orders) == 2
    end
  end
end
