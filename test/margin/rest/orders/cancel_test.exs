defmodule ExHuobi.Rest.Orders.CancelTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias ExHuobi.Margin.Rest.Order, as: Rest

  setup_all do
    HTTPoison.start()
    :ok
  end

  setup do
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes", "fixture/custom_cassettes")
    :ok
  end

  test "cancel order" do
    use_cassette "rest/orders/cancel", custom: true do
      cancel_id = "70662287304"

      params = %{
        "account-id": 123_456_789,
        amount: 0.0001,
        price: 11000,
        symbol: "btcusdt",
        type: "sell-limit",
        source: "super-margin-api"
      }

      {:ok, order} = Rest.cancel(cancel_id)
      assert cancel_id == order.id
    end
  end

  test "cancel order batch" do
    use_cassette "rest/orders/bulk_cancel", custom: true do
      params = %{"order-id": [70_664_141_188, 70_664_141_185]}

      {:ok, orders} = Rest.bulk_cancel(params)
      # assert length(orders) == 2
    end
  end
end
