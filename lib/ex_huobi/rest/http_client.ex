defmodule ExHuobi.Rest.HTTPClient do
  alias ExHuobi.{Config, Util}

  def get(base_url, path, config) do
    case prepare_request("GET", base_url, path, config) do
      {:error, _} = error ->
        error

      {:ok, signed_url} ->
        HTTPoison.get(signed_url)
    end
  end

  def get(base_url, path, params, config) do
    case prepare_request("GET", base_url, path, params, config) do
      {:error, _} = error ->
        error

      {:ok, signed_url} ->
        HTTPoison.get(signed_url)
    end
  end

  def post(base_url, path, params, config) do
    case prepare_request("POST", base_url, path, config) do
      {:error, _} = error ->
        error

      {:ok, signed_url} ->
        HTTPoison.post(signed_url, Jason.encode!(params), headers())
    end
  end

  defp headers, do: ["Content-Type": "application/json"]

  def prepare_request(method, base_url, path, config) do
    case validate_credentials(config) do
      {:error, _} = error ->
        {:error, error}

      {:ok, %Config{api_key: api_key, api_secret: api_secret}} ->
        method_to_sign = method <> "\n"
        host_to_sign = URI.parse(base_url).host <> "\n"
        base_resource_to_sign = path <> "\n"

        text_to_signed =
          %{
            "AccessKeyId" => api_key,
            "SignatureMethod" => "HmacSHA256",
            "SignatureVersion" => 2,
            "Timestamp" => Util.get_timestamp()
          }
          |> URI.encode_query()

        signature =
          Util.sign_content(
            api_secret,
            method_to_sign <> host_to_sign <> base_resource_to_sign <> text_to_signed
          )

        signed_url = base_url <> path <> "?" <> text_to_signed <> "&Signature=#{signature}"
        {:ok, signed_url}
    end
  end

  def prepare_request(method, base_url, path, params, config) do
    case validate_credentials(config) do
      {:error, _} = error ->
        {:error, error}

      {:ok, %Config{api_key: api_key, api_secret: api_secret}} ->
        method_to_sign = method <> "\n"
        host_to_sign = URI.parse(base_url).host <> "\n"
        base_resource_to_sign = path <> "\n"

        default_text_to_sign =
          %{
            "AccessKeyId" => api_key,
            "SignatureMethod" => "HmacSHA256",
            "SignatureVersion" => 2,
            "Timestamp" => Util.get_timestamp()
          }
          |> URI.encode_query()

        params_to_sign = params |> URI.encode_query()
        text_to_sign = default_text_to_sign <> "&" <> params_to_sign

        signature =
          Util.sign_content(
            api_secret,
            method_to_sign <> host_to_sign <> base_resource_to_sign <> text_to_sign
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

# defmodule ExHuobi.Http.Client do
#   import ExHuobi.Config
#
#   # @hbdm_url "https://api.hbdm.com"
#   # @hbdm_host "api.hbdm.com"
#
#   def headers, do: ["Content-Type": "application/json"]
#
#   def get(host, path, params \\ %{}) do
#     url = signed_path("GET", host, path, params)
#
#     url
#     |> HTTPoison.get(headers())
#     |> parse_response()
#   end
#
#   def post(host, path, body) do
#     url = signed_path("POST", host, path, %{})
#
#     url
#     |> HTTPoison.post(Jason.encode!(body), headers())
#     |> parse_response()
#   end
#
#   def timestamp() do
#     {timestamp, _} =
#       DateTime.utc_now()
#       |> DateTime.truncate(:second)
#       |> DateTime.to_iso8601()
#       |> String.split_at(-1)
#
#     timestamp
#   end
#
#   def signed_path(method, host, path, params) do
#     %ExHuobi.Config{api_key: api_key, api_secret: api_secret} = ExHuobi.Config.get(nil)
#
#     api_key = "3c8dd81a-d8b5e97e-qv2d5ctgbn-9bd14"
#     api_secret = "94472b76-30a703ac-e75d7396-c34a0"
#
#     default_params = %{
#       "AccessKeyId" => api_key,
#       "SignatureMethod" => "HmacSHA256",
#       "SignatureVersion" => 2,
#       "Timestamp" => timestamp()
#     }
#
#     params = Map.merge(default_params, params)
#
#     params_string = URI.encode_query(params)
#
#     presigned_text = [method, host, path, params_string] |> Enum.join("\n")
#
#     signature =
#       :sha256
#       |> :crypto.hmac(api_secret, presigned_text)
#       |> Base.encode64()
#
#     request_url = "https://#{host}#{path}?#{params_string}&Signature=#{signature}"
#   end
#
#   def parse_response(response) do
#     case response do
#       {:ok, %HTTPoison.Response{body: body, status_code: status_code}} ->
#         if status_code in 200..299 do
#           {:ok, Jason.decode!(body)}
#         else
#           case Jason.decode(body) do
#             {:ok, json} -> {:error, {json["code"], json["message"]}, status_code}
#             {:error, _} -> {:error, body, status_code}
#           end
#         end
#
#       {:error, %HTTPoison.Error{reason: reason}} ->
#         {:error, reason}
#     end
#   end
# end
