defmodule ExHuobi.Margin.Rest.HTTPClient do
  alias ExHuobi.Util

  @type verb :: :GET | :POST
  @type base_url :: String.t()
  @type path :: String.t()
  @type params :: map
  @type config :: ExHuobi.Config.t()
  @type success_response :: {:ok, any}
  @type failure_response ::
          {:error, {:poison_decode_error, String.t()}}
          | {:error, {:huobi_error, %{code: String.t(), msg: String.t()}}}
          | {:error, {:config_missing, String.t()}}
          | {:error, any}
  @type response :: success_response | failure_response

  @spec get(base_url, path, config) :: response
  def get(base_url, path, config) do
    Util.prepare_request(:GET, base_url, path, config)
    |> HTTPoison.get()
    |> parse_response
  end

  @spec get(base_url, path, params, config) :: response
  def get(base_url, path, params, config) do
    Util.prepare_request(:GET, base_url, path, params, config)
    |> HTTPoison.get()
    |> parse_response
  end

  @spec post(base_url, path, params, config) :: response
  def post(base_url, path, params, config) do
    Util.prepare_request(:POST, base_url, path, config)
    |> HTTPoison.post(Jason.encode!(params), headers())
    |> parse_response
  end

  defp headers, do: ["Content-Type": "application/json"]

  defp parse_response({:ok, response}) do
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