defmodule Huobi.Test do
  def timestamp() do
    {timestamp, _} =
      DateTime.utc_now()
      |> DateTime.truncate(:second)
      |> DateTime.to_iso8601()
      |> String.split_at(-1)

    timestamp
    |> URI.encode_www_form()
  end

  # def sign(method, host, path, params) do

  def create() do
    query_string = "POST\n"
    host = "api.hbdm.com\n"
    path = "/api/v1/contract_order\n"

    params = %{
      "AccessKeyId" => "3c8dd81a-d8b5e97e-qv2d5ctgbn-9bd14",
      "SignatureMethod" => "HmacSHA256",
      "SignatureVersion" => 2,
      "Timestamp" => timestamp()
    }

    params_string = query_string("", params) |> IO.inspect()

    presigned_text = query_string <> host <> path <> params_string

    signature =
      :sha256
      |> :crypto.hmac("94472b76-30a703ac-e75d7396-c34a0", presigned_text)
      |> Base.encode64()

    # api.huobi.pro
    endpoint =
      ("https://api.hbdm.com/api/v1/contract_order" <>
         "?" <> params_string <> "&Signature=#{signature}")
      |> IO.inspect()

    body = %{
      symbol: "BTC",
      contract_type: "this_week",
      volume: 1,
      price: 5000,
      direction: "Buy",
      lever_rate: 5,
      offset: "open",
      order_price_type: "limit"
    }

    IO.inspect(endpoint)
    # body |> Jason.encode!() |> IO.inspect()
    HTTPoison.post!(endpoint, Jason.encode!(body), %{"content-type" => "application/json"})

    # case HTTPoison.post!(endpoint, Jason.encode! body) do
    #   {:error, something}  -> IO.inspect something
    #   _ -> IO.inspect "I dont' know"
    # end
  end

  def cancel(orderId) do
    query_string = "POST\n"
    host = "api.hbdm.com\n"
    path = "/api/v1/contract_cancel\n"

    params = %{
      "AccessKeyId" => "3c8dd81a-d8b5e97e-qv2d5ctgbn-9bd14",
      "SignatureMethod" => "HmacSHA256",
      "SignatureVersion" => 2,
      "Timestamp" => timestamp()
    }

    params_string = query_string("", params) |> IO.inspect()

    presigned_text = query_string <> host <> path <> params_string

    signature =
      :sha256
      |> :crypto.hmac("94472b76-30a703ac-e75d7396-c34a0", presigned_text)
      |> Base.encode64()

    # api.huobi.pro
    endpoint =
      ("https://api.hbdm.com/api/v1/contract_cancel" <>
         "?" <> params_string <> "&Signature=#{signature}")
      |> IO.inspect()

    body = %{
      symbol: "BTC",
      order_id: orderId
    }

    HTTPoison.post!(endpoint, Jason.encode!(body), %{"content-type" => "application/json"})
  end

  def get_position do
    query_string = "POST\n"
    host = "api.hbdm.com\n"
    path = "/api/v1/contract_position_info\n"

    params = %{
      "AccessKeyId" => "3c8dd81a-d8b5e97e-qv2d5ctgbn-9bd14",
      "SignatureMethod" => "HmacSHA256",
      "SignatureVersion" => 2,
      "Timestamp" => timestamp()
    }

    params_string = query_string("", params) |> IO.inspect()

    presigned_text = query_string <> host <> path <> params_string

    signature =
      :sha256
      |> :crypto.hmac("94472b76-30a703ac-e75d7396-c34a0", presigned_text)
      |> Base.encode64()

    # api.huobi.pro
    endpoint =
      ("https://api.hbdm.com/api/v1/contract_position_info" <>
         "?" <> params_string <> "&Signature=#{signature}")
      |> IO.inspect()

    body = %{}

    HTTPoison.get!(endpoint, %{"content-type" => "application/json"})
    # HTTPoison.get!(endpoint, Jason.encode!(body), %{"content-type" => "application/json"})
  end

  def query_string(path, params) do
    query =
      params
      |> Enum.map(fn {key, val} -> "#{key}=#{val}" end)
      |> Enum.join("&")

    # path <> "?" <> query
  end
end
