defmodule ExHuobi.Futures.Rest.Account.Test do
  use ExUnit.Case, async: true

  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    System.put_env("HUOBI_API_KEY", "12343")
    System.put_env("HUOBI_API_SECRET", "12345")
    HTTPoison.start()
  end

  test "" do
    use_cassette("/futures/account/1234") do

      assert ExHuobi.Futures.Rest.Account.get_position("BTC") ==
               {:ok,
                %{"order_id" => 680_494_320_326_811_648, "order_id_str" => "680494320326811648"}}
    end
  end

end
