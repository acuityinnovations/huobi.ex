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
end
