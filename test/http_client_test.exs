defmodule ExHuobi.Rest.HTTPClientTest do
  use ExUnit.Case
  alias ExHuobi.Util
  doctest ExHuobi.Rest.HTTPClient

  @config %ExHuobi.Config{
    api_key: System.get_env("HUOBI_API_KEY"),
    api_secret: System.get_env("HUOBI_API_SECRET")
  }

  describe "test helper functions in http client" do
    test "timestamp should return correct format" do
      timestamp = Util.get_timestamp()
      [date, time] = String.split(timestamp, "T")
      [year, month, date] = String.split(date, "-")
      [hour, minute, second] = String.split(time, ":")

      assert String.length(year) == 4
      assert String.length(month) == 2
      assert String.length(date) == 2

      assert String.length(hour) == 2
      assert String.length(minute) == 2
      assert String.length(second) == 2
    end

    test "should return correct signed_path" do
      signed_path =
        Util.prepare_request(
          :GET,
          "https://api.hbdm.com",
          "/api/v1/contract_order",
          %{
            "key1" => "value1",
            "key2" => "value2"
          },
          @config
        )

      [first, _] = String.split(signed_path, "?")
      assert String.starts_with?(first, "https://api.hbdm.com") == true
      assert String.ends_with?(first, "/api/v1/contract_order") == true
    end
  end
end
