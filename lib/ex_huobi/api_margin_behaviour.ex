defmodule ExHuobi.ApiMarginBehaviour do
  @type params :: map | [map]
  @type config :: map
  @type success_response :: {:ok, String.t()} | {:ok, Order.t()} | {:ok, [Order.t()]}
  @type failure_response ::
          {:error, {:poison_decode_error, String.t()}}
          | {:error, {:huobi_error, %{code: String.t(), msg: String.t()}}}
          | {:error, {:config_missing, String.t()}}
  @type response :: success_response | failure_response

  @callback create(params, config) :: response
  @callback bulk_create(params, config) :: response
  @callback bulk_cancel(params, config) :: response
end
