defmodule ExHuobi.Margin.WebSocket.OrderWs do
  defmacro __using__(_opts) do
    quote do
      use ExHuobi.OrderWs, endpoint: "wss://api.huobi.pro/ws/v1"
    end
  end
end
