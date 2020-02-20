defmodule ExHuobi.Spot.Rest.Account do
  alias ExHuobi.Spot.Rest.HTTPClient

  def get_account(config \\ nil) do
    case HTTPClient.get_huobi("/v1/account/accounts", config) do
      {:ok, data} ->
        IO.inspect data
        {:ok, account} = data |> parse_to_obj()

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
      ExHuobi.Spot.Account,
      transformations: [:snake_case]
    )
  end
end
