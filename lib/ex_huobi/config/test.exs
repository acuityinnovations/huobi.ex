use Mix.Config

config :ex_huobi,
  api_key: System.get_env("HUOBI_API_KEY"),
  api_secret: System.get_env("HUOBI_API_SECRET"),
  api_passphrase: System.get_env("HUOBI_API_PASSPHRASE")
