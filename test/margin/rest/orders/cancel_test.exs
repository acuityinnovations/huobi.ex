defmodule ExHuobi.Rest.Orders.CancelTest do
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

  test "cancel order" do
    use_cassette "rest/orders/cancel", custom: true do
      cancel_id = "70662287304"
      {:ok, order} = Rest.cancel(cancel_id, @config)
      assert cancel_id == order.id
    end
  end

  test "cancel order batch" do
    use_cassette "rest/orders/bulk_cancel", custom: true do
      params = %{"order-id": ["70664141188", "70664141185"]}

      {:ok, data} = Rest.bulk_cancel(params, @config)
      assert length(data["success"]) == 2
    end
  end
end
