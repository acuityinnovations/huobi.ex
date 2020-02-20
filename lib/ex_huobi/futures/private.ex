defmodule ExHuobi.Futures.Private do
  alias ExHuobi.Rest.HTTPClient

  @hbdm_host "api.hbdm.com"

  def create_order(order, config \\ nil) do
    HTTPClient.post(@hbdm_host, "/api/v1/contract_order", order, config)
  end

  def create_bulk_orders(orders, config \\ nil) do
    HTTPClient.post(@hbdm_host, "/api/v1/contract_order", orders, config)
  end

  def cancel_order(order, config \\ nil) do
    HTTPClient.post(@hbdm_host, "/api/v1/contract_cancel", order, config)
  end

  def get_position(instrument_id, config \\ nil) do
    HTTPClient.post(
      @hbdm_host,
      "/api/v1/contract_position_info",
      %{"symbol" => instrument_id},
      config
    )
  end
end
