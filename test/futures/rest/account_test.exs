defmodule ExHuobi.Futures.Rest.Account.Test do
  use ExUnit.Case, async: true

  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  @config %ExHuobi.Config{
    api_key: System.get_env("HUOBI_API_KEY"),
    api_secret: System.get_env("HUOBI_API_SECRET")
  }

  setup_all do
    System.put_env("HUOBI_API_KEY", "12343")
    System.put_env("HUOBI_API_SECRET", "12345")
    HTTPoison.start()
  end

  test "should return position" do
    use_cassette("/futures/account/get_position_success") do
      assert ExHuobi.Futures.Rest.Account.get_position("BTC", @config) ==
               {:ok,
                [
                  %{
                    "available" => 0,
                    "contract_code" => "BTC180914",
                    "contract_type" => "this_week",
                    "cost_hold" => 422.78,
                    "cost_open" => 422.78,
                    "direction" => "buy",
                    "frozen" => 0.3,
                    "last_price" => 7900.17,
                    "lever_rate" => 10,
                    "position_margin" => 3.4,
                    "profit" => 0.97,
                    "profit_rate" => 0.07,
                    "profit_unreal" => 7.096e-5,
                    "symbol" => "BTC",
                    "volume" => 1
                  }
                ]}
    end
  end

  test "should return error when have problem" do
    use_cassette("/futures/account/get_position_error") do
      assert ExHuobi.Futures.Rest.Account.get_position("BTC", @config) ==
               {:error,
                %{
                  "err_code" => 403,
                  "err_msg" => "Incorrect Access key [Access key错误]",
                  "status" => "error",
                  "ts" => 1_582_522_621_658
                }}
    end
  end
end
