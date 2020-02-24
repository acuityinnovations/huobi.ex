defmodule ExHuobi.Futures.Rest.Account do
  alias ExHuobi.Rest.HTTPClient
  alias ExHuobi.Futures.Util

  @type config :: ExHuobi.Config.config_or_nil
  @type position :: map

  @hbdm_host "https://api.hbdm.com"

  @spec get_position(String.t(), config | nil) :: {:error, any} | {:ok, any}
  def get_position(instrument_id, config \\ nil) do
    HTTPClient.post(
      @hbdm_host,
      "/api/v1/contract_position_info",
      %{"symbol" => instrument_id},
      config
    )
    |> Util.parse_response()
  end
end
