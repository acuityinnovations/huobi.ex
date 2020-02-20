defmodule ExHuobi.Margin.Rest.Account do
  alias ExHuobi.Margin.Rest.HTTPClient

  @get_account_path "/v1/account/accounts"

  def get_account(config) do
    case HTTPClient.get_huobi(@get_account_path, config) do
      {:ok, data} ->
        {:ok, data |> parse_to_obj()}

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
      ExHuobi.Margin.Account,
      transformations: [:snake_case]
    )
  end
end
