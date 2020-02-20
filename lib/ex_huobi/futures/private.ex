defmodule ExHuobi.Futures.Private do
  import Huobi.Http.Client

  @hbdm_host "api.hbdm.com"

  def create_order(order) do
    post(@hbdm_host, "/api/v1/contract_order", order)
  end

  def create_bulk_orders(orders) do
    post(@hbdm_host, "/api/v1/contract_order", orders)
  end

  def cancel_order(order) do
    post(@hbdm_host, "/api/v1/contract_cancel", order)
  end

  def get_position(instrument_id) do
    post(@hbdm_host, "/api/v1/contract_position_info", instrument_id)
  end

end
