defmodule ExHuobi.Util do
  @moduledoc false

  @doc """
  Sign a given string using given key
  """
  def sign_content(key, content) do
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
end
