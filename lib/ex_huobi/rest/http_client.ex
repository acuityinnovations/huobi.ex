defmodule ExHuobi.Rest.HTTPClient do
  alias ExHuobi.Util

  @type verb :: :GET | :POST
  @type base_url :: String.t()
  @type path :: String.t()
  @type params :: map | list
  @type config :: ExHuobi.Config.t() | nil
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
  end

  @spec get(base_url, path, params, config) :: response
  def get(base_url, path, params, config) do
    Util.prepare_request(:GET, base_url, path, params, config)
    |> HTTPoison.get()
  end

  @spec post(base_url, path, params, config) :: response
  def post(base_url, path, params, config) do
    Util.prepare_request(:POST, base_url, path, config)
    |> HTTPoison.post(Jason.encode!(params), headers())
  end

  defp headers, do: ["Content-Type": "application/json"]
end
