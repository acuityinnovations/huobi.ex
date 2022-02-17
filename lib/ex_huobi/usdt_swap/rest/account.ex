defmodule ExHuobi.UsdtSwap.Rest.Account do
  @moduledoc false

  alias ExHuobi.Rest.HTTPClient
  alias ExHuobi.UsdtSwap.Rest.Handler

  @type config :: map
  @type position :: map

  @hbdm_host "https://api.hbdm.com"

  @spec get_positions(String.t(), config) :: {:error, any} | {:ok, any}
  def get_positions(instrument_id, config) do
    @hbdm_host
    |> HTTPClient.post(
      "/linear-swap-api/v1/swap_cross_position_info",
      %{"contract_code" => instrument_id},
      config
    )
    |> Handler.parse_response()
  end

  @spec get_account_info(String.t(), config) :: {:error, any} | {:ok, any}
  def get_account_info(instrument_id, config) do
    @hbdm_host
    |> HTTPClient.post(
      "/linear-swap-api/v1/swap_cross_account_info",
      %{"contract_code" => instrument_id},
      config
    )
    |> Handler.parse_response()
  end

  @spec get_all_positions(config) :: {:error, any} | {:ok, any}
  def get_all_positions(config) do
    @hbdm_host
    |> HTTPClient.post(
         "/linear-swap-api/v1/swap_cross_position_info",
         %{},
         config
       )
    |> Handler.parse_response()
  end

  @spec get_all_accounts(config) :: {:error, any} | {:ok, any}
  def get_all_accounts(config) do
    @hbdm_host
    |> HTTPClient.post(
         "/linear-swap-api/v1/swap_cross_account_info",
         %{},
         config
       )
    |> Handler.parse_response()
  end
end
