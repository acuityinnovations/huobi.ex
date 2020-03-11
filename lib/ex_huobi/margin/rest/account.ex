defmodule ExHuobi.Margin.Rest.Account do
  alias ExHuobi.Rest.HTTPClient
  alias ExHuobi.Margin.Account, as: AccountModel
  alias ExHuobi.Margin.Rest.Handler
  alias ExHuobi.Util

  @margin_endpoint "https://api.huobi.pro"

  @type params :: map
  @type config :: map
  @type success_response :: {:ok, integer} | {:ok, Account.t()} | {:ok, [Account.t()]}
  @type failure_response ::
          {:error, {:poison_decode_error, String.t()}}
          | {:error, {:huobi_error, %{code: String.t(), msg: String.t()}}}
  @type response :: success_response | failure_response

  @spec get(config) :: response
  def get(config) do
    @margin_endpoint
    |> HTTPClient.get("/v1/account/accounts", config)
    |> Handler.parse_response()
    |> Util.transform_response_data(AccountModel)
  end
end
