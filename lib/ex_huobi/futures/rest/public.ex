defmodule ExHuobi.Futures.Rest.Public do
  alias ExHuobi.Rest.HTTPClient
  alias ExHuobi.Futures.Rest.Handler

  @hbdm_host "https://api.hbdm.com"

  @spec instruments() :: {:error, any} | {:ok, map}
  def instruments() do
    @hbdm_host
    |> HTTPClient.get(
      "/api/v1/contract_contract_info",
      nil
    )
    |> Handler.parse_response()
  end

  def instrument_info(instrument_id) do
    HTTPoison.get("#{@hbdm_host}/api/v1/contract_contract_info?contract_code=#{instrument_id}")
    |> Handler.parse_response()
  end

  def get_price_limit(instrument_id) do
    HTTPoison.get("#{@hbdm_host}/api/v1/contract_price_limit?contract_code=#{instrument_id}")
    |> Handler.parse_response()
  end
end
