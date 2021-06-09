defmodule ExHuobi.Futures.Rest.Public do
  @moduledoc false

  alias ExHuobi.Futures.Rest.Handler

  @hbdm_host "https://api.hbdm.com"

  @spec instruments() :: {:error, any} | {:ok, map}
  def instruments do
    HTTPoison.get("#{@hbdm_host}/api/v1/contract_contract_info")
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

  def get_last_trade(instrument_id) do
    instrument_id = String.downcase(instrument_id)

    HTTPoison.get("#{@hbdm_host}/market/trade?symbol=#{instrument_id}")
    |> Handler.parse_response()
  end

  def get_market_depth(instrument) do
    HTTPoison.get("#{@hbdm_host}/market/depth?symbol=#{instrument}&type=step0")
    |> Handler.parse_response()
  end
end
