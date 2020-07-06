defmodule ExHuobi.Swap.Rest.Account.Test do
  use ExUnit.Case, async: true

  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias ExHuobi.Swap.Rest.Account, as: AccountApi

  setup_all do
    HTTPoison.start()

    %{config: nil}
  end

  test "should return account information with leverage", %{config: config} do
    use_cassette("swap/account/get_account_info_success") do
      assert AccountApi.get_account_info("BTC-USD", config) ==
               {:ok,
                [
                  %{
                    "adjust_factor" => 0.04,
                    "contract_code" => "BTC-USD",
                    "lever_rate" => 5,
                    "liquidation_price" => 4033.8781574205373,
                    "margin_available" => 0.011784280039968068,
                    "margin_balance" => 0.013984960050091196,
                    "margin_frozen" => 0.0,
                    "margin_position" => 0.002200680010123128,
                    "margin_static" => 0.013984960050091196,
                    "profit_real" => -4.9989949908804e-5,
                    "profit_unreal" => 0.0,
                    "risk_rate" => 6.31483577156169,
                    "symbol" => "BTC",
                    "withdraw_available" => 0.011784280039968068
                  }
                ]}
    end
  end

  test "should return position", %{config: config} do
    use_cassette("swap/account/get_position_success") do
      assert AccountApi.get_positions("BTC-USD", config) ==
               {:ok,
                [
                  %{
                    "symbol" => "BTC",
                    "contract_code" => "BTC-USD",
                    "lever_rate" => 5,
                    "profit_unreal" => 3.632124483e-7,
                    "adjust_factor" => 0.04,
                    "liquidation_price" => 4033.8781574205373,
                    "margin_available" => 0.01178471589490603,
                    "margin_balance" => 0.013985323262539496,
                    "margin_frozen" => 0.0,
                    "margin_position" => 0.002200607367633466,
                    "margin_static" => 0.013984960050091196,
                    "positions" => [
                      %{
                        "available" => 1.0,
                        "contract_code" => "BTC-USD",
                        "cost_hold" => 9088.1,
                        "cost_open" => 9088.1,
                        "direction" => "buy",
                        "frozen" => 0.0,
                        "last_price" => 9088.4,
                        "lever_rate" => 5,
                        "position_margin" => 0.002200607367633466,
                        "profit" => 3.632124483e-7,
                        "profit_rate" => 1.65045552572405e-4,
                        "profit_unreal" => 3.632124483e-7,
                        "symbol" => "BTC",
                        "volume" => 1.0
                      }
                    ],
                    "profit_real" => -4.9989949908804e-5,
                    "risk_rate" => 6.3152105969632,
                    "withdraw_available" => 0.01178435268245773
                  }
                ]}
    end
  end
end
