defmodule ExHuobi.Margin.Rest.Account do
  @moduledoc false

  alias ExHuobi.Margin.Account, as: AccountModel
  alias ExHuobi.Margin.Balance
  alias ExHuobi.Margin.Rest.Handler
  alias ExHuobi.Rest.HTTPClient
  alias ExHuobi.Util

  @margin_endpoint "https://api.huobi.pro"

  @type params :: map
  @type config :: map
  @type success_response :: {:ok, integer} | {:ok, AccountModel.t()} | {:ok, [AccountModel.t()]}
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

  @spec get_balances(integer, config) :: response
  def get_balances(account_id, config) do
    @margin_endpoint
    |> HTTPClient.get("/v1/account/accounts/#{account_id}/balance", config)
    |> Handler.parse_response()
    |> Util.transform_response_data(Balance)
  end
end
