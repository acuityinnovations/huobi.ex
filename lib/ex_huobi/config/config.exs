use Mix.Config

config :binance,
  api_key: "",
  secret_key: ""

config :exvcr,
  vcr_cassette_library_dir: "fixture/vcr_cassettes",
  custom_cassette_library_dir: "fixture/custom_cassettes",
  filter_url_params: true,
  filter_request_headers: [],
  response_headers_blacklist: []
