defmodule Huobi.Http.Client do

  import Huobi.Config
  
  # @hbdm_url "https://api.hbdm.com"
  # @hbdm_host "api.hbdm.com"
  
  def headers, do: ["Content-Type": "application/json"]

  def get(host, path, params \\ %{}) do
    url = signed_path("GET", host, path, params)
    url
      |> HTTPoison.get(headers())
      |> parse_response()
  end

  def post(host, path, body) do
    url = signed_path("POST", host, path, %{}) |> IO.inspect

    url
      |> HTTPoison.post(Jason.encode!(body), headers())
      |> IO.inspect
      |> parse_response()      
  end

  def timestamp() do
    {timestamp, _} =
      DateTime.utc_now()
      |> DateTime.truncate(:second)
      |> DateTime.to_iso8601()
      |> String.split_at(-1)

    timestamp
  end

  def signed_path(method, host, path, params) do

    %Huobi.Config{api_key: api_key, api_secret: api_secret} = Huobi.Config.get(nil)

    api_key = "3c8dd81a-d8b5e97e-qv2d5ctgbn-9bd14"
    api_secret = "94472b76-30a703ac-e75d7396-c34a0"

    default_params = %{
      "AccessKeyId" => api_key,
      "SignatureMethod" => "HmacSHA256",
      "SignatureVersion" => 2,
      "Timestamp" => timestamp()
    } |> IO.inspect
    params = Map.merge(default_params, params)

    params_string = URI.encode_query(params)
    
    presigned_text = [method, host, path, params_string] |> Enum.join("\n")
    signature =
      :sha256
      |> :crypto.hmac(api_secret, presigned_text)
      |> Base.encode64()

    request_url = "https://#{host}#{path}?#{params_string}&Signature=#{signature}" 
      |> IO.inspect
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
