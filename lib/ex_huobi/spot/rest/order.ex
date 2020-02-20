defmodule ExHuobi.Spot.Rest.Order do
  alias ExHuobi.Spot.Rest.HTTPClient


  def get_order(order_id, config \\ nil) do
    case HTTPClient.get_huobi("/v1/order/orders/#{order_id}", config) do
      {:ok, data} ->
        IO.inspect data
        {:ok, order} = data |> parse_to_obj()

      error ->
        error
    end
  end


  # ExHuobi.Spot.Rest.Order.create_order(%{"account-id": 12035991, amount: 0.00001, price: 11000 , symbol: "btcusdt", type: "sell-limit"})
  def create_order(
        %{"account-id": account_id, amount: amount, price: price, symbol: symbol, type: type} = params,
        config \\ nil
      ) do

    case HTTPClient.post_huobi("/v1/order/orders/place", params, config) do
      {:ok, data} ->
        {:ok, %ExHuobi.Spot.Order{id: data}}

      error ->
        error
    end
  end

  # ExHuobi.Spot.Rest.Order.get_open_orders(%{"account-id": 12035991, symbol: "btcusdt"})

  def get_open_orders(%{"account-id": account_id, symbol: symbol} = params, config \\ nil) do
    case HTTPClient.get_new_huobi("/v1/order/openOrders", params, config) do
      {:ok, data} ->
        {:ok, order} = data |> parse_to_obj()

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
      ExHuobi.Spot.Order,
      transformations: [:snake_case]
    )
  end

end
