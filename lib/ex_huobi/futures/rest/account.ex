defmodule ExHuobi.Futures.Rest.Account do
  alias ExHuobi.Rest.HTTPClient
  alias ExHuobi.Futures.Rest.Handler

  @type config :: ExHuobi.Config.t() | nil
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
    |> Handler.parse_response()
  end
end
