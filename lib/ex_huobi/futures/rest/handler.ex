defmodule ExHuobi.Futures.Rest.Handler do
  @moduledoc false

  @spec parse_response({:error, HTTPoison.Error.t()} | {:ok, HTTPoison.Response.t()}) ::
          {:error, any} | {:ok, any}
  @doc false
  def parse_response(response) do
    case response do
      {:ok, %HTTPoison.Response{body: body, status_code: status_code}} ->
        handle_success_response(status_code, body)

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  defp handle_success_response(status_code, body) do
    if status_code in 200..299 do
      case Jason.decode!(body) do
        %{"status" => "error"} = error -> {:error, error}
        %{"status" => "ok", "data" => data} -> {:ok, data}
      end
    else
      case Jason.decode(body) do
        {:ok, json} -> {:error, json, status_code}
        {:error, _} -> {:error, body, status_code}
      end
    end
  end
end
