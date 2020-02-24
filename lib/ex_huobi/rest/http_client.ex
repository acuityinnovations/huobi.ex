defmodule ExHuobi.Rest.HTTPClient do
  alias ExHuobi.Util

  @type verb :: :GET | :POST
  @type base_url :: String.t()
  @type path :: String.t()
  @type params :: map
  @type config :: ExHuobi.Config.t()
  @type success_response :: {:ok, map | [map] | integer}
  @type failure_response ::
          {:error, {:poison_decode_error, String.t()}}
          | {:error, {:huobi_error, %{code: String.t(), msg: String.t()}}}
  @type response :: success_response | failure_response

  @spec get(base_url, path, config) :: response
  def get(base_url, path, config) do
    case Util.prepare_request(:GET, base_url, path, config) do
      {:error, _} = error ->
        error

      {:ok, signed_url} ->
        HTTPoison.get(signed_url)
    end
  end

  @spec get(base_url, path, config) :: response
  def get(base_url, path, params, config) do
    case Util.prepare_request(:GET, base_url, path, params, config) do
      {:error, _} = error ->
        error

      {:ok, signed_url} ->
        HTTPoison.get(signed_url)
    end
  end

  @spec post(base_url, path, params, config) :: response
  def post(base_url, path, params, config) do
    case Util.prepare_request(:POST, base_url, path, config) do
      {:error, _} = error ->
        error

      {:ok, signed_url} ->
        HTTPoison.post(signed_url, Jason.encode!(params), headers())
    end
  end

  defp headers, do: ["Content-Type": "application/json"]
end
