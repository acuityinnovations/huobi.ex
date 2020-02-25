defmodule ExHuobi.Util do
  @moduledoc false

  alias ExHuobi.Config

  @type verb :: :GET | :POST
  @type base_url :: String.t()
  @type path :: String.t()
  @type params :: map
  @type config :: Config.t()
  @type response :: String.t()

  defmacro prepare_common(verb, base_url, path, config, do: yield) do
    quote do
      verb_to_sign = unquote(verb) |> Atom.to_string() |> Kernel.<>("\n")
      host_to_sign = unquote(base_url) |> URI.parse() |> Map.get(:host) |> Kernel.<>("\n")
      base_resource_to_sign = unquote(path) |> Kernel.<>("\n")

      text_to_sign = unquote(yield)

      signature =
        sign_content(
          unquote(config).api_secret,
          verb_to_sign <> host_to_sign <> base_resource_to_sign <> text_to_sign
        )

      signed_url =
        unquote(base_url) <> unquote(path) <> "?" <> text_to_sign <> "&Signature=#{signature}"
    end
  end

  @spec prepare_request(verb, base_url, path, config) :: response
  def prepare_request(verb, base_url, path, config) do
    prepare_common(verb, base_url, path, config) do
      config.api_key
      |> get_default_text_to_sign()
      |> URI.encode_query()
    end
  end

  @spec prepare_request(verb, base_url, path, params, config) :: response
  def prepare_request(verb, base_url, path, params, config) do
    prepare_common(verb, base_url, path, config) do
      default_text_to_sign =
        config.api_key
        |> get_default_text_to_sign()
        |> URI.encode_query()

      params_to_sign = params |> URI.encode_query()
      default_text_to_sign <> "&" <> params_to_sign
    end
  end

  def sign_content(key, content) do
    :crypto.hmac(
      :sha256,
      key,
      content
    )
    |> Base.encode64()
  end

  def get_authen_ws_message(config) do
    %{api_key: api_key, api_secret: api_secret} = ExHuobi.Config.get(config)
    time = ExHuobi.Util.get_timestamp()
    default_text_to_sign = get_default_text_to_sign(api_key, time) |> URI.encode_query()
    content = "GET" <> "\n" <> "api.huobi.pro" <> "\n" <> "/ws/v1" <> "\n" <> default_text_to_sign
    signature = sign_content(api_secret, content)

    %{
      op: "auth",
      AccessKeyId: api_key,
      SignatureMethod: "HmacSHA256",
      SignatureVersion: "2",
      Timestamp: time,
      Signature: signature
    }
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

  defp get_default_text_to_sign(api_key, time) do
    %{
      "AccessKeyId" => api_key,
      "SignatureMethod" => "HmacSHA256",
      "SignatureVersion" => 2,
      "Timestamp" => time
    }
  end
end
