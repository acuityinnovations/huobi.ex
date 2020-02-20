defmodule ExHuobi.Futures.Private do
  @prefix "/api/v1"

  # def create_order(param, config | nil) do
  #   query_string = ""

  #   query_string
  #   |> url("https://api.huobi.pro")
  #   |> HTTPoison.post(Jason.encode!(params))
  #   |> parse_response()
  # end

  def create_batch_order(params, config \\ nil) do
  end

  def cancel_order() do
  end

  def cancel_orders() do
  end

  def get_position(instrument_id, config \\ nil) do
  end

  # def query_string(path, params) do
  #   query =
  #     params
  #     |> Enum.map(fn {key, val} -> "#{key}=#{val}" end)
  #     |> Enum.join("&")

  #   path <> "?" <> query
  # end

  # def parse_response(response) do
  #   case response do
  #     {:ok, %HTTPoison.Response{body: body, status_code: status_code}} ->
  #       if status_code in 200..299 do
  #         {:ok, Jason.decode!(body)}
  #       else
  #         case Jason.decode(body) do
  #           {:ok, json} -> {:error, {json["code"], json["message"]}, status_code}
  #           {:error, _} -> {:error, body, status_code}
  #         end
  #       end

  #     {:error, %HTTPoison.Error{reason: reason}} ->
  #       {:error, reason}
  #   end
  # end
end
