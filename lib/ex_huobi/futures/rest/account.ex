defmodule ExHuobi.Futures.Rest.Account do
  @moduledoc false

  alias ExHuobi.Futures.AccountInfo
  alias ExHuobi.Futures.Rest.Handler
  alias ExHuobi.Futures.Position
  alias ExHuobi.Rest.HTTPClient
  alias ExHuobi.Util

  @type config :: map
  @type position :: map

  @hbdm_host "https://api.hbdm.com"

  @spec get_positions(String.t(), config) :: {:error, any} | {:ok, any}
  def get_positions(instrument_id, config) do
    @hbdm_host
    |> HTTPClient.post(
      "/api/v1/contract_account_position_info",
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

  @spec get_all_positions(config) :: {:error, any} | {:ok, any}
  def get_all_positions(config) do
    @hbdm_host
    |> HTTPClient.post("/api/v1/contract_position_info", %{}, config)
    |> Handler.parse_response()
    |> Util.transform_response_data(Position)
  end

  @spec get_all_accounts(config) :: {:error, any} | {:ok, any}
  def get_all_accounts(config) do
    @hbdm_host
    |> HTTPClient.post("/api/v1/contract_account_info", %{}, config)
    |> Handler.parse_response()
    |> Util.transform_response_data(AccountInfo)
  end
end
