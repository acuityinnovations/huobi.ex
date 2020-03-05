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

  test "do somethign here" do
    response = [
      %{
        "adjust_factor" => 0.15,
        "is_debit" => 0,
        "lever_rate" => 20,
        "liquidation_price" => nil,
        "margin_available" => 0.01,
        "margin_balance" => 0.01,
        "margin_frozen" => 0.0,
        "margin_position" => 0,
        "margin_static" => 0.01,
        "profit_real" => 0.0,
        "profit_unreal" => 0,
        "risk_rate" => nil,
        "symbol" => "BTC",
        "withdraw_available" => 0.01
      }
    ]

    Jason.encode(response) |> IO.inspect()
  end

  test "should return account information with leverage" do
    use_cassette("/futures/account/get_account_info_success") do
      config = %ExHuobi.Config{
        api_key: "3c8dd81a-d8b5e97e-qv2d5ctgbn-9bd14",
        api_secret: "94472b76-30a703ac-e75d7396-c34a0"
      }

      ExHuobi.Futures.Rest.Account.get_account_info("BTC", config) |> IO.inspect()
    end
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
