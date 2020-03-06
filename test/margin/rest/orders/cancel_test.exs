defmodule ExHuobi.Rest.Orders.CancelTest do
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

  test "cancel order", %{config: config} do
    use_cassette "rest/orders/cancel", custom: true do
      cancel_id = "70662287304"
      {:ok, order} = Rest.cancel(cancel_id, config)
      assert cancel_id == order
    end
  end

  test "cancel order batch", %{config: config} do
    use_cassette "rest/orders/bulk_cancel", custom: true do
      params = %{"order-id": ["70664141188", "70664141185"]}

      {:ok, data} = Rest.bulk_cancel(params, config)
      assert length(data["success"]) == 2
    end
  end
end
