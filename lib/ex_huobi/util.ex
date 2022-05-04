defmodule ExHuobi.Util do
  @moduledoc false

  @type verb :: :GET | :POST
  @type base_url :: String.t()
  @type path :: String.t()
  @type params :: map
  @type config :: map | nil
  @type response :: String.t()

  defmacro prepare_common(verb, base_url, path, config, do: yield) do
    quote do
      verb_to_sign = unquote(verb) |> Atom.to_string() |> Kernel.<>("\n")
      host_to_sign = unquote(base_url) |> URI.parse() |> Map.get(:host) |> Kernel.<>("\n")
      base_resource_to_sign = unquote(path) |> Kernel.<>("\n")
      %{api_secret: api_secret} = ExHuobi.Config.get(unquote(config))

      text_to_sign = unquote(yield)

      signature =
        sign_content_for_rest(
          api_secret,
          verb_to_sign <> host_to_sign <> base_resource_to_sign <> text_to_sign
        )

      signed_url =
        unquote(base_url) <> unquote(path) <> "?" <> text_to_sign <> "&Signature=#{signature}"
    end
  end

  @spec prepare_request(verb, base_url, path, config) :: response
  def prepare_request(verb, base_url, path, config) do
    prepare_common(verb, base_url, path, config) do
      %{api_key: api_key} = ExHuobi.Config.get(config)

      api_key
      |> get_default_text_to_sign()
      |> URI.encode_query()
    end
  end

  @spec prepare_request(verb, base_url, path, params, config) :: response
  def prepare_request(verb, base_url, path, params, config) do
    prepare_common(verb, base_url, path, config) do
      %{api_key: api_key} = ExHuobi.Config.get(config)

      default_text_to_sign =
        api_key
        |> get_default_text_to_sign()
        |> URI.encode_query()

      params_to_sign = params |> URI.encode_query()
      default_text_to_sign <> "&" <> params_to_sign
    end
  end

  def sign_content_for_ws(key, content) do
    if Code.ensure_loaded?(:crypto) and function_exported?(:crypto, :mac, 4) do
      :hmac
      |> :crypto.mac(:sha256, key, content)
      |> Base.encode16()
    else
      :sha256
      |> :crypto.hmac(key, content)
      |> Base.encode16()
    end
  end

  def sign_content_for_rest(key, content) do
    if Code.ensure_loaded?(:crypto) and function_exported?(:crypto, :mac, 4) do
      :hmac
      |> :crypto.mac(:sha256, key, content)
      |> Base.encode16()
      |> URI.encode_www_form()
    else
      :sha256
      |> :crypto.hmac(key, content)
      |> Base.encode16()
      |> URI.encode_www_form()
    end
  end

  def get_authen_ws_message(config, endpoint, is_future? \\ false) do
    %{api_key: api_key, api_secret: api_secret} = ExHuobi.Config.get(config)
    %{host: host, path: path} = URI.parse(endpoint)
    time = ExHuobi.Util.get_timestamp()
    default_text_to_sign = get_default_text_to_sign(api_key, time) |> URI.encode_query()
    content = "GET" <> "\n" <> host <> "\n" <> path <> "\n" <> default_text_to_sign
    signature = sign_content_for_ws(api_secret, content)

    authen_payload = %{
      op: "auth",
      AccessKeyId: api_key,
      SignatureMethod: "HmacSHA256",
      SignatureVersion: "2",
      Timestamp: time,
      Signature: signature
    }

    if is_future? do
      Map.put_new(authen_payload, :type, "api")
    else
      authen_payload
    end
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

  def transform_response_data(response, module) do
    case response do
      {:ok, data} -> {:ok, data |> parse_to_struct(module)}
      {:error, error} -> {:error, error}
    end
  end

  defp parse_to_struct(data, module) when is_list(data) do
    data
    |> Enum.map(&to_struct(&1, module))
  end

  defp parse_to_struct(data, module) when is_map(data) do
    data |> to_struct(module)
  end

  defp to_struct(data, module) do
    {:ok, obj} =
      data
      |> Mapail.map_to_struct(
        module,
        transformations: [:snake_case]
      )

    obj
  end
end
