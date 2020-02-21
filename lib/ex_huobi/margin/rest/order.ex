defmodule ExHuobi.Margin.Rest.Order do
  alias ExHuobi.Rest.HTTPClient
  alias ExHuobi.Margin.Order
  @margin_endpoint "https://api.huobi.pro"

  @type order_id :: integer
  @type params :: map | [map]
  @type config :: Config.t()
  @type success_response :: {:ok, integer} | {:ok, Order.t()} | {:ok, [Order.t()]}
  @type failure_response ::
          {:error, {:poison_decode_error, String.t()}}
          | {:error, {:huobi_error, %{code: String.t(), msg: String.t()}}}
  @type response :: success_response | failure_response

  @spec get(order_id, config) :: response
  def get(order_id, config \\ nil) do
    case HTTPClient.get(@margin_endpoint, "/v1/order/orders/#{order_id}", config) do
      {:ok, data} ->
        {:ok, data |> parse_to_obj()}

      {:error, error} ->
        {:error, error}
    end
  end

  @doc """
  Create orders.
  ## Examples

    iex> ExHuobi.Margin.Rest.Order.create(%{"account-id": 12035991, amount: 0.0001, price: 11000 , symbol: "btcusdt", type: "sell-limit", source: "super-margin-api"})
  """
  @spec create(params, config) :: response
  def create(params, config \\ nil) do
    case HTTPClient.post(@margin_endpoint, "/v1/order/orders/place", params, config) do
      {:ok, data} ->
        {:ok, %Order{id: data}}

      {:error, error} ->
        {:error, error}
    end
  end

  @doc """
  Bulk create orders.
  ## Examples

    iex> ExHuobi.Margin.Rest.Order.bulk_create([
      %{"account-id": 12035991, amount: 0.0001, price: 11000 , symbol: "btcusdt", type: "sell-limit", source: "super-margin-api"},
      %{"account-id": 12035991, amount: 0.0001, price: 11500 , symbol: "btcusdt", type: "sell-limit", source: "super-margin-api"}
    ])
  """
  @spec bulk_create(params, config) :: response
  def bulk_create(params, config \\ nil) do
    case HTTPClient.post(@margin_endpoint, "/v1/order/batch-orders", params, config) do
      {:ok, data} ->
        {:ok, data |> transform() |> parse_to_obj()}

      {:error, error} ->
        {:error, error}
    end
  end

  defp transform(data) do
    data |> Enum.map(fn el -> Map.put(el, "id", el["order-id"]) end)
  end

  @doc """
  Get open orders.
  ## Examples

    iex> ExHuobi.Margin.Rest.Order.get_open(%{"account-id": 12035991, symbol: "btcusdt"})
  """
  @spec get_open(params, config) :: response
  def get_open(params, config \\ nil) do
    case HTTPClient.get(@margin_endpoint, "/v1/order/openOrders", params, config) do
      {:ok, data} ->
        {:ok, data |> parse_to_obj()}

      {:error, error} ->
        {:error, error}
    end
  end

  @doc """
  Cancel order.
  ## Examples

    iex> ExHuobi.Margin.Rest.Order.cancel_order(70469904946)
  """
  @spec cancel(order_id, config) :: response
  def cancel(order_id, config \\ nil) do
    case HTTPClient.post(
           @margin_endpoint,
           "/v1/order/orders/#{order_id}/submitcancel",
           "",
           config
         ) do
      {:ok, order_id} ->
        {:ok, %Order{id: order_id}}

      {:error, error} ->
        {:error, error}
    end
  end

  @doc """
  Bulk cancel order.
  ## Examples

    iex> ExHuobi.Margin.Rest.Order.bulk_cancel(%{"order-ids": [70664141188, 70664141185]})
  """
  @spec bulk_cancel(params, config) :: response
  def bulk_cancel(params, config \\ nil) do
    case HTTPClient.post(@margin_endpoint, "/v1/order/orders/batchcancel", params, config) do
      {:ok, data} ->
        {:ok, data}

      {:error, error} ->
        {:error, error}
    end
  end

  defp parse_to_obj(data) when is_list(data) do
    data
    |> Enum.map(&to_struct/1)
  end

  defp parse_to_obj(data) when is_map(data) do
    data |> to_struct
  end

  defp to_struct(data) do
    {:ok, obj} =
      data
      |> Mapail.map_to_struct(
        Order,
        transformations: [:snake_case]
      )

    obj
  end
end
