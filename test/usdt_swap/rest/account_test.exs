defmodule ExHuobi.UsdtSwap.Rest.Account.Test do
  use ExUnit.Case, async: true

  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias ExHuobi.UsdtSwap.Rest.Account, as: AccountApi

  setup_all do
    HTTPoison.start()

    %{config: nil}
  end

  test "should return account information with leverage", %{config: config} do
    use_cassette("usdt_swap/account/get_account_info_success") do
      assert AccountApi.get_account_info("USDT", config) ==
               {:ok,
                [
                  %{
                    "margin_account" => "USDT",
                    "margin_asset" => "USDT",
                    "margin_mode" => "cross",
                    "profit_unreal" => -0.1132,
                    "contract_detail" => [
                      %{
                        "adjust_factor" => 0.04,
                        "contract_code" => "BTC-USDT",
                        "lever_rate" => 5,
                        "liquidation_price" => nil,
                        "margin_available" => 47.85274442,
                        "margin_frozen" => 0.0,
                        "margin_position" => 7.40012,
                        "profit_unreal" => -0.1132,
                        "symbol" => "BTC"
                      },
                      %{
                        "adjust_factor" => 0.06,
                        "contract_code" => "ETH-USDT",
                        "lever_rate" => 5,
                        "liquidation_price" => nil,
                        "margin_available" => 47.85274442,
                        "margin_frozen" => 0,
                        "margin_position" => 0,
                        "profit_unreal" => 0.0,
                        "symbol" => "ETH"
                      },
                      %{
                        "adjust_factor" => 0.075,
                        "contract_code" => "XRP-USDT",
                        "lever_rate" => 5,
                        "liquidation_price" => nil,
                        "margin_available" => 47.85274442,
                        "margin_frozen" => 0,
                        "margin_position" => 0,
                        "profit_unreal" => 0.0,
                        "symbol" => "XRP"
                      },
                      %{
                        "adjust_factor" => 0.06,
                        "contract_code" => "LTC-USDT",
                        "lever_rate" => 5,
                        "liquidation_price" => nil,
                        "margin_available" => 47.85274442,
                        "margin_frozen" => 0,
                        "margin_position" => 0,
                        "profit_unreal" => 0.0,
                        "symbol" => "LTC"
                      },
                      %{
                        "adjust_factor" => 0.1,
                        "contract_code" => "LINK-USDT",
                        "lever_rate" => 5,
                        "liquidation_price" => nil,
                        "margin_available" => 47.85274442,
                        "margin_frozen" => 0,
                        "margin_position" => 0,
                        "profit_unreal" => 0.0,
                        "symbol" => "LINK"
                      },
                      %{
                        "adjust_factor" => 0.1,
                        "contract_code" => "TRX-USDT",
                        "lever_rate" => 5,
                        "liquidation_price" => nil,
                        "margin_available" => 47.85274442,
                        "margin_frozen" => 0,
                        "margin_position" => 0,
                        "profit_unreal" => 0.0,
                        "symbol" => "TRX"
                      },
                      %{
                        "adjust_factor" => 0.1,
                        "contract_code" => "DOT-USDT",
                        "lever_rate" => 5,
                        "liquidation_price" => nil,
                        "margin_available" => 47.85274442,
                        "margin_frozen" => 0,
                        "margin_position" => 0,
                        "profit_unreal" => 0.0,
                        "symbol" => "DOT"
                      },
                      %{
                        "adjust_factor" => 0.1,
                        "contract_code" => "ADA-USDT",
                        "lever_rate" => 5,
                        "liquidation_price" => nil,
                        "margin_available" => 47.85274442,
                        "margin_frozen" => 0,
                        "margin_position" => 0,
                        "profit_unreal" => 0.0,
                        "symbol" => "ADA"
                      },
                      %{
                        "adjust_factor" => 0.06,
                        "contract_code" => "EOS-USDT",
                        "lever_rate" => 5,
                        "liquidation_price" => nil,
                        "margin_available" => 47.85274442,
                        "margin_frozen" => 0,
                        "margin_position" => 0,
                        "profit_unreal" => 0.0,
                        "symbol" => "EOS"
                      },
                      %{
                        "adjust_factor" => 0.06,
                        "contract_code" => "BCH-USDT",
                        "lever_rate" => 5,
                        "liquidation_price" => nil,
                        "margin_available" => 47.85274442,
                        "margin_frozen" => 0,
                        "margin_position" => 0,
                        "profit_unreal" => 0.0,
                        "symbol" => "BCH"
                      },
                      %{
                        "adjust_factor" => 0.1,
                        "contract_code" => "BSV-USDT",
                        "lever_rate" => 5,
                        "liquidation_price" => nil,
                        "margin_available" => 47.85274442,
                        "margin_frozen" => 0,
                        "margin_position" => 0,
                        "profit_unreal" => 0.0,
                        "symbol" => "BSV"
                      },
                      %{
                        "adjust_factor" => 0.1,
                        "contract_code" => "YFI-USDT",
                        "lever_rate" => 5,
                        "liquidation_price" => nil,
                        "margin_available" => 47.85274442,
                        "margin_frozen" => 0,
                        "margin_position" => 0,
                        "profit_unreal" => 0.0,
                        "symbol" => "YFI"
                      },
                      %{
                        "adjust_factor" => 0.1,
                        "contract_code" => "UNI-USDT",
                        "lever_rate" => 5,
                        "liquidation_price" => nil,
                        "margin_available" => 47.85274442,
                        "margin_frozen" => 0,
                        "margin_position" => 0,
                        "profit_unreal" => 0.0,
                        "symbol" => "UNI"
                      }
                    ],
                    "margin_balance" => 55.25286442,
                    "margin_frozen" => 0.0,
                    "margin_position" => 7.40012,
                    "margin_static" => 55.36606442,
                    "profit_real" => -0.00742276,
                    "risk_rate" => 185.66205554774788,
                    "withdraw_available" => 47.85274442
                  }
                ]}
    end
  end

  test "should return position", %{config: config} do
    use_cassette("usdt_swap/account/get_position_success") do
      assert AccountApi.get_positions("BTC-USDT", config) ==
               {:ok,
                [
                  %{
                    "margin_account" => "USDT",
                    "margin_asset" => "USDT",
                    "margin_mode" => "cross",
                    "profit_unreal" => -0.0141,
                    "available" => 1.0,
                    "contract_code" => "BTC-USDT",
                    "cost_hold" => 37113.8,
                    "cost_open" => 37113.8,
                    "direction" => "buy",
                    "frozen" => 0.0,
                    "last_price" => 37099.7,
                    "lever_rate" => 5,
                    "position_margin" => 7.41994,
                    "profit" => -0.0141,
                    "profit_rate" => -0.00189956296579709,
                    "symbol" => "BTC",
                    "volume" => 1.0
                  }
                ]}
    end
  end
end
