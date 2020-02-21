defmodule ExHuobi.Util do
  @moduledoc false

  alias ExHuobi.Config

  @type verb :: :GET | :POST
  @type base_url :: String.t()
  @type path :: String.t()
  @type params :: map
  @type config :: Config.t()
  @type auth_response :: {:ok, Config.t()} | {:error, {:config_missing, String.t()}}

  @spec prepare_request(verb, base_url, path, config) :: auth_response
  def prepare_request(verb, base_url, path, config) do
    case validate_credentials(config) do
      {:error, error} ->
        {:error, error}

      {:ok, %Config{api_key: api_key, api_secret: api_secret}} ->
        verb_to_sign = verb |> Atom.to_string() |> Kernel.<>("\n")
        host_to_sign = URI.parse(base_url).host <> "\n"
        base_resource_to_sign = path <> "\n"

        text_to_sign =
          api_key
          |> get_default_text_to_sign()
          |> URI.encode_query()

        signature =
          sign_content(
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
        verb_to_sign = verb |> Atom.to_string() |> Kernel.<>("\n")
        host_to_sign = URI.parse(base_url).host <> "\n"
        base_resource_to_sign = path <> "\n"

        default_text_to_sign =
          api_key
          |> get_default_text_to_sign()
          |> URI.encode_query()

        params_to_sign = params |> URI.encode_query()
        text_to_sign = default_text_to_sign <> "&" <> params_to_sign

        signature =
          sign_content(
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

  defp sign_content(key, content) do
    :crypto.hmac(
      :sha256,
      key,
      content
    )
    |> Base.encode64()
  end

  def get_timestamp do
    {timestamp, _} =
      DateTime.utc_now()
      |> DateTime.truncate(:second)
      |> DateTime.to_iso8601()
      |> String.split_at(-1)

    timestamp
  end

  defp get_default_text_to_sign(api_key) do
    %{
      "AccessKeyId" => api_key,
      "SignatureMethod" => "HmacSHA256",
      "SignatureVersion" => 2,
      "Timestamp" => get_timestamp()
    }
  end
end
