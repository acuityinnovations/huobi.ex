defmodule ExHuobi.Futures.Rest.Account do
  alias ExHuobi.Rest.HTTPClient

  @type params :: map
  @type config :: ExHuobi.Config.t()

  @hbdm_host "https://api.hbdm.com"

  def get_position(instrument_id, config \\ nil) do
    HTTPClient.post(
      @hbdm_host,
      "/api/v1/contract_position_info",
      %{"symbol" => instrument_id},
      config
    )
  end
end
