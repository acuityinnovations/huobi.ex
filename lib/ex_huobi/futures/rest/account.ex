defmodule ExHuobi.Futures.Rest.Account do
  alias ExHuobi.Rest.HTTPClient
  alias ExHuobi.Futures.Rest.Handler
  alias ExHuobi.Util
  alias ExHuobi.Futures.AccountInfo

  @type config :: map
  @type position :: map

  @hbdm_host "https://api.hbdm.com"

  @spec get_position(String.t(), config) :: {:error, any} | {:ok, any}
  def get_position(instrument_id, config) do
    @hbdm_host
    |> HTTPClient.post(
      "/api/v1/contract_position_info",
      %{"symbol" => instrument_id},
      config
    )
    |> Handler.parse_response()
  end

  @spec get_account_info(String.t(), config) :: {:error, any} | {:ok, any}
  def get_account_info(instrument_id, config) do
    @hbdm_host
    |> HTTPClient.post(
      "/api/v1/contract_account_info",
      %{"symbol" => instrument_id},
      config
    )
    |> Handler.parse_response()
    |> Util.transform_response_data(AccountInfo)
  end
end
