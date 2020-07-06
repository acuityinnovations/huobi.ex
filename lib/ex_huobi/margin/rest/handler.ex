defmodule ExHuobi.Margin.Rest.Handler do
  @moduledoc false

  def parse_response({:ok, response}) do
    response.body
    |> Jason.decode()
    |> case do
      {:ok, %{"status" => "error", "err-code" => err_code, "err-msg" => err_msg}} ->
        {:error, {:huobi_error, %{code: err_code, msg: err_msg}}}

      {:ok, %{"status" => "ok", "data" => [%{"err-code" => err_code, "err-msg" => err_msg}, _]}} ->
        {:error, {:huobi_error, %{code: err_code, msg: err_msg}}}

      {:ok, %{"status" => "ok", "data" => data}} ->
        {:ok, data}

      {:error, error} ->
        {:error, {:poison_decode_error, error}}
    end
  end
end
