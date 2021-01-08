defmodule ExHuobi.UsdtSwap.Rest.Public.Test do
  use ExUnit.Case, async: true

  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias ExHuobi.UsdtSwap.Rest.Public, as: PublicApi

  setup_all do
    HTTPoison.start()
  end

  test "get price limit" do
    use_cassette("/usdt_swap/public/get_price_limit") do
      assert PublicApi.get_price_limit("BTC-USDT") ==
               {:ok,
                [
                  %{
                    "contract_code" => "BTC-USDT",
                    "symbol" => "BTC",
                    "high_limit" => 38310.5,
                    "low_limit" => 35363.6
                  }
                ]}
    end
  end

  test "get best tickers" do
    use_cassette("/usdt_swap/public/get_best_ticker") do
      assert PublicApi.get_best_ticker("BTC-USDT") ==
               {:ok,
                %{
                  "amount" => "378391.442",
                  "ask" => [36956.8, 14974],
                  "bid" => [36956.7, 1],
                  "close" => "36956.7",
                  "count" => 1_136_452,
                  "high" => "37762.3",
                  "id" => 1_610_006_003,
                  "low" => "34279.9",
                  "open" => "34590.3",
                  "ts" => 1_610_006_003_496,
                  "vol" => "378391442",
                  "trade_turnover" => "13475374208.0956"
                }}
    end
  end

  test "get instruments info" do
    use_cassette("/usdt_swap/public/instruments") do
      assert PublicApi.instruments("BTC-USDT") ==
               {:ok,
                [
                  %{
                    "contract_status" => 1,
                    "price_tick" => 0.1,
                    "symbol" => "BTC",
                    "contract_code" => "BTC-USDT",
                    "contract_size" => 0.001,
                    "create_date" => "20201021",
                    "settlement_date" => "1610006400000",
                    "support_margin_mode" => "all"
                  }
                ]}
    end
  end
end
