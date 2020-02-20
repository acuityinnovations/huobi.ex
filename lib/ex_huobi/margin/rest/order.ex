defmodule ExHuobi.Margin.Rest.Order do
  alias ExHuobi.Margin.Rest.HTTPClient


  def get_order(order_id, config \\ nil) do
    case HTTPClient.get_huobi("/v1/order/orders/#{order_id}", config) do
      {:ok, data} ->
        {:ok, data |> parse_to_obj()}

      error ->
        error
    end
  end

  # ExHuobi.Margin.Rest.Order.create_order(%{"account-id": 12035991, amount: 0.00001, price: 11000 , symbol: "btcusdt", type: "sell-limit"})
  def create_order(
        %{"account-id": _account_id, amount: _amount, price: _price, symbol: _symbol, type: _type} =
          params,
        config \\ nil
      ) do
    case HTTPClient.post_huobi("/v1/order/orders/place", params, config) do
      {:ok, data} ->
        {:ok, %ExHuobi.Margin.Order{id: data}}

      error ->
        error
    end
  end

  # ExHuobi.Margin.Rest.Order.get_open_orders(%{"account-id": 12035991, symbol: "btcusdt"})

  def get_open_orders(%{"account-id": _account_id, symbol: _symbol} = params, config \\ nil) do
    case HTTPClient.get_huobi("/v1/order/openOrders", params, config) do
      {:ok, data} ->
        {:ok, data |> parse_to_obj()}

      error ->
        error
    end
  end


  # ExHuobi.Margin.Rest.Order.cancel_order(70469904946)
  def cancel_order(order_id, config \\ nil) do
    case HTTPClient.post_huobi("/v1/order/orders/#{order_id}/submitcancel", "", config) do
      {:ok, data} ->
        {:ok, %ExHuobi.Margin.Order{id: data}}

      error ->
        error
    end
  end

  defp parse_to_obj(data) when is_list(data) do
    objs =
      data
      |> Enum.map(&to_struct/1)
      |> Enum.map(fn {:ok, o} -> o end)

    {:ok, objs}
  end

  defp parse_to_obj(data) when is_map(data) do
    {:ok, obj} = data |> to_struct
    {:ok, obj}
  end

  defp to_struct(data) do
    data
    |> Mapail.map_to_struct(
      ExHuobi.Margin.Order,
      transformations: [:snake_case]
    )
  end
end
