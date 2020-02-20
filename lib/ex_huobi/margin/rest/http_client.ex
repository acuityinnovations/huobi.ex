# defmodule ExHuobi.Margin.Rest.HTTPClient do
#   @base_url "https://api.huobi.pro"
#
#   alias ExHuobi.{Config, Util}
#
#   def get_huobi(url, config) do
#     case prepare_request("GET", url, config) do
#       {:error, _} = error ->
#         error
#
#       {:ok, signed_url} ->
#         HTTPoison.get(signed_url)
#         |> parse_response
#     end
#   end
#
#   def get_huobi(url, params, config) do
#     case prepare_request("GET", url, params, config) do
#       {:error, _} = error ->
#         error
#
#       {:ok, signed_url} ->
#         HTTPoison.get(signed_url)
#         |> parse_response
#     end
#   end
#
#   def post_huobi(url, params, config) do
#     case prepare_request("POST", url, config) do
#       {:error, _} = error ->
#         error
#
#       {:ok, signed_url} ->
#         HTTPoison.post(signed_url, Jason.encode!(params), [{"Content-Type", "application/json"}])
#         |> parse_response
#     end
#   end
#
#   defp prepare_request(method, url, config) do
#     case validate_credentials(config) do
#       {:error, _} = error ->
#         {:error, error}
#
#       {:ok, %Config{api_key: api_key, api_secret: api_secret}} ->
#         method_to_sign = method <> "\n"
#         host_to_sign = URI.parse(@base_url).host <> "\n"
#         base_resource_to_sign = url <> "\n"
#
#         text_to_signed =
#           %{
#             "AccessKeyId" => api_key,
#             "SignatureMethod" => "HmacSHA256",
#             "SignatureVersion" => 2,
#             "Timestamp" => Util.get_timestamp()
#           }
#           |> URI.encode_query()
#
#         signature =
#           Util.sign_content(
#             api_secret,
#             method_to_sign <> host_to_sign <> base_resource_to_sign <> text_to_signed
#           )
#
#         signed_url = @base_url <> url <> "?" <> text_to_signed <> "&Signature=#{signature}"
#         {:ok, signed_url}
#     end
#   end
#
#   defp prepare_request(method, url, params, config) do
#     case validate_credentials(config) do
#       {:error, _} = error ->
#         {:error, error}
#
#       {:ok, %Config{api_key: api_key, api_secret: api_secret}} ->
#         method_to_sign = method <> "\n"
#         host_to_sign = URI.parse(@base_url).host <> "\n"
#         base_resource_to_sign = url <> "\n"
#
#         default_text_to_sign =
#           %{
#             "AccessKeyId" => api_key,
#             "SignatureMethod" => "HmacSHA256",
#             "SignatureVersion" => 2,
#             "Timestamp" => Util.get_timestamp()
#           }
#           |> URI.encode_query()
#
#         params_to_sign = params |> URI.encode_query()
#         text_to_sign = default_text_to_sign <> "&" <> params_to_sign
#
#         signature =
#           Util.sign_content(
#             api_secret,
#             method_to_sign <> host_to_sign <> base_resource_to_sign <> text_to_sign
#           )
#
#         signed_url = @base_url <> url <> "?" <> text_to_sign <> "&Signature=#{signature}"
#         {:ok, signed_url}
#     end
#   end
#
#   defp validate_credentials(config) do
#     case Config.get(config) do
#       %Config{api_key: api_key, api_secret: api_secret} = config
#       when is_binary(api_key) and is_binary(api_secret) ->
#         {:ok, config}
#
#       _ ->
#         {:error, {:config_missing, "Secret or API key missing"}}
#     end
#   end
#
#   defp parse_response({:ok, %{status_code: status_code} = response})
#        when status_code not in 200..299 do
#     response.body
#     |> Poison.decode()
#     |> case do
#       {:ok, %{"status" => "error", "err-code" => err_code, "err-msg" => err_msg}} ->
#         {:error, {:huobi_error, %{code: err_code, msg: err_msg}}}
#
#       {:error, error} ->
#         {:error, {:poison_decode_error, error}}
#     end
#   end
#
#   defp parse_response({:ok, response}) do
#     response.body
#     |> Poison.decode()
#     |> case do
#       {:ok, %{"status" => "error", "err-code" => err_code, "err-msg" => err_msg}} ->
#         {:error, {:huobi_error, %{code: err_code, msg: err_msg}}}
#
#       {:ok, %{"status" => "ok", "data" => data}} ->
#         {:ok, data}
#
#       {:error, error} ->
#         {:error, {:poison_decode_error, error}}
#     end
#   end
# end
