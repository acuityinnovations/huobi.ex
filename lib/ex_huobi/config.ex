defmodule ExHuobi.Config do
  require Logger

  @type t :: %ExHuobi.Config{
          api_key: String.t(),
          api_secret: String.t()
        }

  @enforce_keys [:api_key, :api_secret]
  defstruct [:api_key, :api_secret]

  @doc """
  Get default API configs

  ## Examples
      iex> ExHuobi.Config.get()
  """
  def get(nil) do
    %__MODULE__{
      api_key: System.get_env("HUOBI_API_KEY"),
      api_secret: System.get_env("HUOBI_API_SECRET")
    }
  end

  @doc """
  Get dynamic API configs via ENVs

  ## Examples
      iex> ExHuobi.Config.get(%{access_keys: ["H1_API_KEY", "H1_API_SECRET"]})
  """
  def get(%{
        access_keys: [api_key_access, api_secret_access]
      }) do
    %__MODULE__{
      api_key: System.get_env(api_key_access),
      api_secret: System.get_env(api_secret_access)
    }
  end

  def get(_) do
    Logger.error("Incorrect config setup.")
  end
end
