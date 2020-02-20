defmodule Huobi.Http.Client do

  import Huobi.Config
  
  # @hbdm_url "https://api.hbdm.com"
  # @hbdm_host "api.hbdm.com"
  
  def headers, do: ["Content-Type": "application/json"]

  def get(host, path, params) do
    url = signed_path("GET", host, path, params)
    url
      |> HTTPoison.get(headers)
      |> parse_response()
  end

  def post(host, path, body) do
    url = signed_path("POST", host, path, [])

    url
      |> HTTPoison.post(Jason.encode!(body))
      |> parse_response()
      def timestamp() do
  end

    {timestamp, _} =
      DateTime.utc_now()
      |> DateTime.truncate(:second)
      |> DateTime.to_iso8601()
      |> String.split_at(-1)

    timestamp
      |> URI.encode_www_form()
  end

  def signed_path(method, host, path, params) do
    config = Config.config

    access_key_id = ""
    access_key_secret = ""


    default_params = %{
      "AccessKeyId" => access_key_id,
      "SignatureMethod" => "HmacSHA256",
      "SignatureVersion" => 2,
      "Timestamp" => timestamp()
    }
    params = default_params ++ params

    params_string = URI.encode_query(params)
    presigned_text = method <> host <> path <> params_string
    signature =
      :sha256
      |> :crypto.hmac(access_key_secret, presigned_text)
      |> Base.encode64()

    request_url = "https://#{request_url}?#{params_string}&Signature=#{signature}"
  end

  def parse_response(response) do
    case response do
      {:ok, %HTTPoison.Response{body: body, status_code: status_code}} ->
        if status_code in 200..299 do
          {:ok, Jason.decode!(body)}
        else
          case Jason.decode(body) do
            {:ok, json} -> {:error, {json["code"], json["message"]}, status_code}
            {:error, _} -> {:error, body, status_code}
          end
        end

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
