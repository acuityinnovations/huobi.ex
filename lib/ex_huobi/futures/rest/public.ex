defmodule ExHuobi.Futures.Rest.Public do
  alias ExHuobi.Futures.Rest.Handler

  @hbdm_host "https://api.hbdm.com"

  @spec instruments() :: {:error, any} | {:ok, map}
  def instruments do
    HTTPoison.get("#{@hbdm_host}/api/v1/contract_contract_info")
    |> Handler.parse_response()
  end
end
