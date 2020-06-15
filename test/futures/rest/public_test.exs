defmodule ExHuobi.Futures.Rest.Public.Test do
  use ExUnit.Case, async: true

  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    HTTPoison.start()
  end

  test "should return futures instruments" do
    use_cassette("futures/public/get_instruments") do
      assert ExHuobi.Futures.Rest.Public.instruments() ==
               {:ok,
                [
                  %{
                    "contract_code" => "BTC200320",
                    "contract_size" => 100.0,
                    "contract_status" => 1,
                    "contract_type" => "this_week",
                    "create_date" => "20200306",
                    "delivery_date" => "20200320",
                    "price_tick" => 0.01,
                    "symbol" => "BTC"
                  },
                  %{
                    "contract_code" => "BTC200327",
                    "contract_size" => 100.0,
                    "contract_status" => 1,
                    "contract_type" => "next_week",
                    "create_date" => "20191213",
                    "delivery_date" => "20200327",
                    "price_tick" => 0.01,
                    "symbol" => "BTC"
                  },
                  %{
                    "contract_code" => "BTC200626",
                    "contract_size" => 100.0,
                    "contract_status" => 1,
                    "contract_type" => "quarter",
                    "create_date" => "20200313",
                    "delivery_date" => "20200626",
                    "price_tick" => 0.01,
                    "symbol" => "BTC"
                  }
                ]}
    end
  end

  test "should return correct contract instrument info" do
    use_cassette("futures/public/get_instrument") do
      assert ExHuobi.Futures.Rest.Public.instrument_info("BTC200327") ==
               {:ok,
                [
                  %{
                    "contract_code" => "BTC200327",
                    "contract_size" => 100.0,
                    "contract_status" => 1,
                    "contract_type" => "this_week",
                    "create_date" => "20191213",
                    "delivery_date" => "20200327",
                    "price_tick" => 0.01,
                    "symbol" => "BTC"
                  }
                ]}
    end
  end

  test "should return correct high and low price" do
    use_cassette("futures/public/get_price_limit") do
      assert ExHuobi.Futures.Rest.Public.get_price_limit("BTC200327") ==
               {:ok,
                [
                  %{
                    "contract_code" => "BTC200327",
                    "contract_type" => "this_week",
                    "high_limit" => 6920.74,
                    "low_limit" => 6421.43,
                    "symbol" => "BTC"
                  }
                ]}
    end
  end

  test "should return market depth" do
    use_cassette("futures/public/get_market_depth") do
      assert ExHuobi.Futures.Rest.Public.get_market_depth("BTC_CQ") ==
               {:ok,
                %{"asks" => [[9253.66, 711], [9254.35,7], [9254.36,79]],
                "bids" => [[9253.65, 379], [9253.23,20], [9253.09,10]],
                "ch" => "market.BTC_CQ.depth.step0",
                "id" => 1592196800,
                "mrid" => 73995840218,
                "ts" => 1592196800542,
                "version" => 1592196800}
              }
    end
  end
end
