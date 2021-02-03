defmodule ExHuobi.Margin.Rest.Order do
  @moduledoc false

  alias ExHuobi.Margin.Order
  alias ExHuobi.Margin.Rest.Handler
  alias ExHuobi.Rest.HTTPClient
  alias ExHuobi.Util

  @margin_endpoint "https://api.huobi.pro"

  @type order_id :: integer
  @type params :: map | [map]
  @type config :: map
  @type success_response :: {:ok, String.t()} | {:ok, Order.t()} | {:ok, [Order.t()]}
  @type failure_response ::
          {:error, {:poison_decode_error, String.t()}}
          | {:error, {:huobi_error, %{code: String.t(), msg: String.t()}}}
          | {:error, {:config_missing, String.t()}}
  @type response :: success_response | failure_response

  @spec get(order_id, config) :: response
  def get(order_id, config) do
    @margin_endpoint
    |> HTTPClient.get("/v1/order/orders/#{order_id}", config)
    |> Handler.parse_response()
    |> Util.transform_response_data(Order)
  end

  @doc """
  Get open orders.
  ## Examples

    iex> ExHuobi.Margin.Rest.Order.get_open(%{"account-id": 12035991, symbol: "btcusdt"}, config)
  """
  @spec get_open(params, config) :: response
  def get_open(params, config) do
    @margin_endpoint
    |> HTTPClient.get("/v1/order/openOrders", params, config)
    |> Handler.parse_response()
    |> Util.transform_response_data(Order)
  end

  @doc """
  Create orders.
  ## Examples

  iex> ExHuobi.Margin.Rest.Order.create(
    %{
      "account-id": 12035991,
      amount: 0.001,
      price: 9900,
      symbol: "btcusdt",
      type: "sell-limit",
      source: "super-margin-api"
    },
    config)

  {:ok, "158599112243250"}
  """
  @spec create(params, config) :: response
  def create(params, config) do
    @margin_endpoint
    |> HTTPClient.post("/v1/order/orders/place", params, config)
    |> Handler.parse_response()
  end

  @doc """
  Bulk create orders.
  ## Examples

  ExHuobi.Margin.Rest.Order.bulk_create([
    %{"account-id": 12035991, amount: 100, price: 11000 , symbol: "btcusdt", type: "buy-limit", source: "super-margin-api"},
    %{"account-id": 12035991, amount: 0.001, price: 11500 , symbol: "btcusdt", type: "buy-limit", source: "super-margin-api"}
  ], config)

  {:ok,
   [
     %{"client-order-id" => "", "order-id" => 159199275270793},
     %{"client-order-id" => "", "order-id" => 159199275270794}
   ]}
  """
  @spec bulk_create(params, config) :: response
  def bulk_create(params, config) do
    @margin_endpoint
    |> HTTPClient.post("/v1/order/batch-orders", params, config)
    |> Handler.parse_response()
  end

  @doc """
  Cancel order.
  ## Examples

    iex> ExHuobi.Margin.Rest.Order.cancel(70469904946, config)
  """
  @spec cancel(order_id, config) :: response
  def cancel(order_id, config) do
    @margin_endpoint
    |> HTTPClient.post(
      "/v1/order/orders/#{order_id}/submitcancel",
      %{},
      config
    )
    |> Handler.parse_response()
  end

  def cancel_all(params, config) do
    @margin_endpoint
    |> HTTPClient.post(
      "/v1/order/orders/batchCancelOpenOrders",
      params,
      config
    )
    |> Handler.parse_response()
  end

  @doc """
  Bulk cancel order.
  ## Examples

    iex> ExHuobi.Margin.Rest.Order.bulk_cancel(%{"order-ids": [70664141188, 70664141185]}, config)
  """
  @spec bulk_cancel(params, config) :: response
  def bulk_cancel(params, config) do
    @margin_endpoint
    |> HTTPClient.post("/v1/order/orders/batchcancel", params, config)
    |> Handler.parse_response()
  end
end
