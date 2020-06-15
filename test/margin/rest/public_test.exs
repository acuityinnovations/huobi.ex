defmodule ExHuobi.Rest.PublicTest do
  use ExUnit.Case, async: true

  alias ExHuobi.Margin.Rest.Public

  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  setup_all do
    HTTPoison.start()

    %{config: nil}
  end

  test "get best bid offer" do
    use_cassette "margin/public/get_best_ticker" do
      assert Public.get_best_ticker() ==
         {:ok,
          [
            %{"amount" => 15596854.0, "ask" => 2.036e-7, "askSize" => 40994.0, "bid" => 2.004e-7, "bidSize" => 17037.0, "close" => 2.021e-7, "count" => 2578, "high" => 2.12e-7, "low" => 1.986e-7, "open" => 2.116e-7, "symbol" => "tnbbtc", "vol" => 3.2917122351},
            %{"amount" => 225627.61162014, "ask" => 4.9e-6, "askSize" => 2409.15, "bid" => 4.87e-6, "bidSize" => 2884.51, "close" => 4.87e-6, "count" => 1123, "high" => 5.01e-6, "low" => 4.87e-6, "open" => 4.98e-6, "symbol" => "paybtc", "vol" => 1.1282820009}
          ]
        }
    end
  end
end
