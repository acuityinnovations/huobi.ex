defmodule ExHuobi.Rest.HTTPClientTest do
  use ExUnit.Case
  doctest ExHuobi.Rest.HTTPClient

  describe "test helper functions in http client" do
    test "timestamp should return correct format" do
      timestamp = ExHuobi.Rest.HTTPClient.timestamp()
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
        ExHuobi.Rest.HTTPClient.signed_path("GET", "api.hbdm.com", "/api/v1/contract_order", %{
          "key1" => "value1",
          "key2" => "value2"
        })

        [first, second] = String.split(signed_path, "?") |>IO.inspect
        assert String.starts_with?("https://api.hbdm.com") == true
        assert String.ends_with?("/api/v1/contract_order") == true
    end
  end
end
