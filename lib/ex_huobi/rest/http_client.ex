defmodule ExHuobi.Rest.HTTPClient do
  alias ExHuobi.{Config, Util}

  @type verb :: :GET | :POST
  @type base_url :: String.t()
  @type path :: String.t()
  @type params :: map
  @type config :: ExHuobi.Config.t()
  @type success_response :: {:ok, map | [map] | integer}
  @type err_code :: String.t()
  @type err_msg :: String.t()
  @type error :: String.t()
  @type failure_response :: {:error, {:poison_decode_error, error}} | {:error, {:huobi_error, %{code: err_code, msg: err_msg}}}
  @type response :: success_response | failure_response
  @type auth_response :: {:ok, String.t()} | {:error, error}

  @spec get(base_url, path, config) :: response
  def get(base_url, path, config) do
    case prepare_request(:GET, base_url, path, config) do
      {:error, _} = error ->
        error

      {:ok, signed_url} ->
        HTTPoison.get(signed_url)
    end
  end

  @spec get(base_url, path, config) :: response
  def get(base_url, path, params, config) do
    case prepare_request(:GET, base_url, path, params, config) do
      {:error, _} = error ->
        error

      {:ok, signed_url} ->
        HTTPoison.get(signed_url)
    end
  end

  @spec post(base_url, path, params, config) :: response
  def post(base_url, path, params, config) do
    case prepare_request(:POST, base_url, path, config) do
      {:error, _} = error ->
        error

      {:ok, signed_url} ->
        HTTPoison.post(signed_url, Jason.encode!(params), headers())
    end
  end

  defp headers, do: ["Content-Type": "application/json"]

  defp get_default_text_to_sign(api_key) do
    %{
      "AccessKeyId" => api_key,
      "SignatureMethod" => "HmacSHA256",
      "SignatureVersion" => 2,
      "Timestamp" => Util.get_timestamp()
    }
  end

  @spec prepare_request(verb, base_url, path, config) :: auth_response
  def prepare_request(verb, base_url, path, config) do
    case validate_credentials(config) do
      {:error, _} = error ->
        {:error, error}

      {:ok, %Config{api_key: api_key, api_secret: api_secret}} ->
        verb_to_sign = verb |> Atom.to_string() |>  Kernel.<>("\n")
        host_to_sign = URI.parse(base_url).host <> "\n"
        base_resource_to_sign = path <> "\n"

        text_to_sign = api_key
          |> get_default_text_to_sign()
          |> URI.encode_query()

        signature =
          Util.sign_content(
            api_secret,
            verb_to_sign <> host_to_sign <> base_resource_to_sign <> text_to_sign
          )

        signed_url = base_url <> path <> "?" <> text_to_sign <> "&Signature=#{signature}"
        {:ok, signed_url}
    end
  end

  @spec prepare_request(verb, base_url, path, params, config) :: auth_response
  def prepare_request(verb, base_url, path, params, config) do
    case validate_credentials(config) do
      {:error, error} ->
        {:error, error}

      {:ok, %Config{api_key: api_key, api_secret: api_secret}} ->
        verb_to_sign = verb |> Atom.to_string() |>  Kernel.<>("\n")
        host_to_sign = URI.parse(base_url).host <> "\n"
        base_resource_to_sign = path <> "\n"

        default_text_to_sign = api_key
          |> get_default_text_to_sign()
          |> URI.encode_query()

        params_to_sign = params |> URI.encode_query()
        text_to_sign = default_text_to_sign <> "&" <> params_to_sign

        signature =
          Util.sign_content(
            api_secret,
            verb_to_sign <> host_to_sign <> base_resource_to_sign <> text_to_sign
          )

        signed_url = base_url <> path <> "?" <> text_to_sign <> "&Signature=#{signature}"
        {:ok, signed_url}
    end
  end

  defp validate_credentials(config) do
    case Config.get(config) do
      %Config{api_key: api_key, api_secret: api_secret} = config
      when is_binary(api_key) and is_binary(api_secret) ->
        {:ok, config}

      _ ->
        {:error, {:config_missing, "Secret or API key missing"}}
    end
  end
end
