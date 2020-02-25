defmodule ExHuobi.Margin.WebSocket.MarketWs do
  defmacro __using__(_opts) do
    quote do
      use ExHuobi.MarketWs, endpoint: "wss://api.huobi.pro/ws"
    end
  end
end
