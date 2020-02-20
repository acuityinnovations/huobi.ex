defmodule ExHuobi.Futures.Private do
  import ExHuobi.Rest.HTTPClient

  @hbdm_host "api.hbdm.com"

  def create_order(order) do
    HTTPClient.post(@hbdm_host, "/api/v1/contract_order", order)
  end

  def create_bulk_orders(orders) do
    HTTPClient.post(@hbdm_host, "/api/v1/contract_order", orders)
  end

  def cancel_order(order) do
    HTTPClient.post(@hbdm_host, "/api/v1/contract_cancel", order)
  end

  def get_position(instrument_id) do
    HTTPClient.post(@hbdm_host, "/api/v1/contract_position_info", %{"symbol" => instrument_id})
  end
end
