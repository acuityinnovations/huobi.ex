defmodule ExHuobi.Margin.Rest.Loan do
  @moduledoc false

  alias ExHuobi.Margin.Rest.Handler
  alias ExHuobi.Rest.HTTPClient

  @margin_endpoint "https://api.huobi.pro"

  @type params :: map
  @type config :: map
  @type success_response :: {:ok, integer}
  @type failure_response ::
          {:error, {:poison_decode_error, String.t()}}
          | {:error, {:huobi_error, %{code: String.t(), msg: String.t()}}}
  @type response :: success_response | failure_response

  @doc """
  Borrow tokens
  ## Examples

  iex> ExHuobi.Margin.Rest.Loan.borrow(
    %{
      symbol: "btcusdt",
      currency: "usdt",
      amount: 0.001
    },
    config)
  """
  @spec borrow(params, config) :: response
  def borrow(params, config) do
    @margin_endpoint
    |> HTTPClient.post("/v1/margin/orders", params, config)
    |> Handler.parse_response()
  end
end
