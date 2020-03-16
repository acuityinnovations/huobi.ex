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
end
