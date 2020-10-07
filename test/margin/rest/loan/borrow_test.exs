defmodule ExHuobi.Margin.Rest.BorrowTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias ExHuobi.Margin.Rest.Loan, as: Rest

  setup_all do
    HTTPoison.start()
    %{config: nil}
  end

  test "borrow tokens", %{config: config} do
    use_cassette "margin/borrow_token_success" do
      {:ok, _} = Rest.borrow(%{symbol: "btcusdt", currency: "usdt", amount: 10}, config)
    end
  end
end
