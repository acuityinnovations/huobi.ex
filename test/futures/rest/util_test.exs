defmodule ExHuobi.Futures.Rest.HandlerTest do
  alias ExHuobi.Futures.Rest.Handler, as: Util

  use ExUnit.Case, async: true

  test "should parse success response" do
    response =
      {:ok,
       %HTTPoison.Response{
         status_code: 200,
         body:
           "{\"status\":\"ok\",\"data\":{\"order_id\":680494320326811648,\"order_id_str\":\"680494320326811648\"},\"ts\":1582284088944}"
       }}

    assert Util.parse_response(response) ==
             {:ok,
              %{
                "order_id" => 680_494_320_326_811_648,
                "order_id_str" => "680494320326811648"
              }}
  end

  test "should parse incorret access key" do
    response =
      {:ok,
       %HTTPoison.Response{
         status_code: 200,
         body:
           "{\"status\":\"error\",\"err_code\":403,\"err_msg\":\"Incorrect Access key [Access key错误]\",\"ts\":1582453227285}"
       }}

    assert Util.parse_response(response) ==
             {:error,
              %{
                "err_code" => 403,
                "err_msg" => "Incorrect Access key [Access key错误]",
                "status" => "error",
                "ts" => 1_582_453_227_285
              }}
  end

  test "should parse insufficient margin error" do
    response =
      {:ok,
       %HTTPoison.Response{
         status_code: 200,
         body:
           "{\"status\":\"error\",\"err_code\":1047,\"err_msg\":\"Insufficient margin available.\",\"ts\":1582453227285}"
       }}

    assert Util.parse_response(response) ==
             {:error,
              %{
                "status" => "error",
                "ts" => 1_582_453_227_285,
                "err_code" => 1047,
                "err_msg" => "Insufficient margin available."
              }}
  end

  test "should parse httpoison error" do
    response = {:error, %HTTPoison.Error{reason: "Some httpoison reason."}}

    assert Util.parse_response(response) == {:error, "Some httpoison reason."}
  end
end
