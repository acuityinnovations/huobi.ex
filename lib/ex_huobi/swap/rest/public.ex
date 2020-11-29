defmodule ExHuobi.Swap.Rest.Public do
  @moduledoc false

  alias ExHuobi.Swap.Rest.Handler

  @hbdm_host "https://api.hbdm.com"

  def get_price_limit(instrument_id) do
    HTTPoison.get("#{@hbdm_host}/swap-api/v1/swap_price_limit?contract_code=#{instrument_id}")
    |> Handler.parse_response()
  end

  @spec get_best_ticker(String.t()) :: {:error, any} | {:ok, list}
  def get_best_ticker(instrument_id) do
    HTTPoison.get("#{@hbdm_host}/swap-ex/market/detail/merged?contract_code=#{instrument_id}")
    |> Handler.parse_response()
  end

  def instruments(instrument_id) do
    HTTPoison.get("#{@hbdm_host}/swap-api/v1/swap_contract_info?contract_code=#{instrument_id}")
    |> Handler.parse_response()
  end

  def get_index_price(instrument_id) do
    HTTPoison.get("#{@hbdm_host}/swap-api/v1/swap_index?contract_code=#{instrument_id}")
    |> Handler.parse_response()
  end
end
