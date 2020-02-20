defmodule ExHuobi.Futures.Private do
  import Huobi.Api.Private

  @hbdm_url "https://api.hbdm.com"

  def create_order(order) do
    post(host, "/api/v1/contract_order", Jason.encode!(order))
  end

  def create_bulk_orders(orders) do
    post(host, "/api/v1/contract_order", Jason.encode!(orders))
  end

  def cancel_order(order) do
    post(host, "/api/v1/contract_cancel", Jason.encode!(order))
  end

  def get_position(instrument_id) do
    post(host, "api/v1/contract_position_info", Jason.encode!(instrument_id))
  end

end
