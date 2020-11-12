defmodule ExHuobi.Swap.Rest.Public.Test do
  use ExUnit.Case, async: true

  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias ExHuobi.Swap.Rest.Public, as: PublicApi

  setup_all do
    HTTPoison.start()
  end

  test "get price limit" do
    use_cassette("/swap/public/get_price_limit") do
      assert PublicApi.get_price_limit("BTC-USD") ==
               {:ok,
                [
                  %{
                    "contract_code" => "BTC-USD",
                    "high_limit" => 9553.5,
                    "low_limit" => 8818.7,
                    "symbol" => "BTC"
                  }
                ]}
    end
  end

  test "get best tickers" do
    use_cassette("/swap/public/get_best_ticker") do
      assert PublicApi.get_best_ticker("BTC-USD") ==
               {:ok,
                %{
                  "amount" => "216673.2394006582973334338854967581133363592",
                  "ask" => [9185.1, 23_622],
                  "bid" => [9185, 7669],
                  "close" => "9185.1",
                  "count" => 202_184,
                  "high" => "9238",
                  "id" => 1_594_025_476,
                  "low" => "8906.8",
                  "open" => "9030.9",
                  "ts" => 1_594_025_476_916,
                  "vol" => "19678582"
                }}
    end
  end

  test "get instruments info" do
    use_cassette("/swap/public/instruments") do
      assert PublicApi.instruments("BTC-USD") ==
               {:ok,
                [
                  %{
                    "contract_code" => "BTC-USD",
                    "contract_size" => 100.0,
                    "contract_status" => 1,
                    "create_date" => "20200325",
                    "price_tick" => 0.1,
                    "settlement_date" => "1605168000000",
                    "symbol" => "BTC"
                  }
                ]}
    end
  end
end
