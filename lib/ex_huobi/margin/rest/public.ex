defmodule ExHuobi.Margin.Rest.Public do
  alias ExHuobi.Margin.Rest.Handler

  @hbdm_host "https://api.huobi.pro"

  @spec get_best_ticker() :: {:error, any} | {:ok, list}
  def get_best_ticker() do
    HTTPoison.get("#{@hbdm_host}/market/tickers")
    |> Handler.parse_response()
  end
end
