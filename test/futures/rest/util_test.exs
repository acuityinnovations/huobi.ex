defmodule ExHuobi.Futures.Rest.UtilTest do
  use ExUnit.Case, async: true
  doctest Futures.Rest.Util


  describe "should parse ok response" do
    response = {:ok, %HTTPoison.Response{body: "{\"status\":\"error\",\"err_code\":403,\"err_msg\":\"Incorrect Access key [Access key错误]\",\"ts\":1582453227285}"}}


    ExHuobi.Futures.Util.parse_response(response)

  end
end
