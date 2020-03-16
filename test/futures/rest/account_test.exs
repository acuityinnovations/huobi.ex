defmodule ExHuobi.Futures.Rest.Account.Test do
  use ExUnit.Case, async: true

  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    HTTPoison.start()

    %{config: nil}
  end

  test "should return account information with leverage", %{config: config} do
    use_cassette("futures/account/get_account_info_success") do
      assert ExHuobi.Futures.Rest.Account.get_account_info("BTC", config) ==
               {:ok,
                [
                  %ExHuobi.Futures.AccountInfo{
                    adjust_factor: 0.025,
                    is_debit: 0,
                    lever_rate: 5,
                    liquidation_price: nil,
                    margin_available: 0,
                    margin_balance: 0,
                    margin_frozen: 0,
                    margin_position: 0,
                    margin_static: 0,
                    profit_real: 0,
                    profit_unreal: 0,
                    risk_rate: nil,
                    symbol: "BTC",
                    withdraw_available: 0
                  }
                ]}
    end
  end

  test "should return position", %{config: config} do
    use_cassette("futures/account/get_position_success") do
      assert ExHuobi.Futures.Rest.Account.get_positions("BTC", config) ==
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

  test "should return error when have problem", %{config: config} do
    use_cassette("futures/account/get_position_error") do
      assert ExHuobi.Futures.Rest.Account.get_positions("BTC", config) ==
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
