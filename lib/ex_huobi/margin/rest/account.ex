defmodule ExHuobi.Margin.Rest.Account do
  alias ExHuobi.Rest.HTTPClient
  alias ExHuobi.Margin.Account
  @margin_endpoint "https://api.huobi.pro"

  @type params :: map
  @type config :: Config.t()
  @type success_response :: {:ok, integer} | {:ok, Account.t()} | {:ok, [Account.t()]}
  @type failure_response ::
          {:error, {:poison_decode_error, String.t()}}
          | {:error, {:huobi_error, %{code: String.t(), msg: String.t()}}}
  @type response :: success_response | failure_response

  @spec get(config) :: response
  def get(config \\ nil) do
    case HTTPClient.get(@margin_endpoint, "/v1/account/accounts", config) do
      {:ok, data} ->
        {:ok, data |> parse_to_obj()}

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
        Account,
        transformations: [:snake_case]
      )

    obj
  end
end
