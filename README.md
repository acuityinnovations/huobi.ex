# ExHuobi

Huobi API Client for Elixir

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ex_huobi` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_huobi, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ex_huobi](https://hexdocs.pm/ex_huobi).


## Margin Rest API Usage

```elixir
config = %ExHuobi.Config{
  api_key: System.get_env("HUOBI_API_KEY"),
  api_secret: System.get_env("HUOBI_API_SECRET")
}

# Single API

# Get account info
ExHuobi.Margin.Rest.Account.get(config)

# Create a new order
ExHuobi.Margin.Rest.Order.create(
  %{
    "account-id": 12345678,
    amount: 0.001,
    price: 9900,
    symbol: "btcusdt",
    type: "sell-limit",
    source: "super-margin-api"
  },
  config
)

# Cancel an order
ExHuobi.Margin.Rest.Order.cancel(70662287304, config)


# Bulk API

# Create multiple orders
ExHuobi.Margin.Rest.Order.bulk_create(
  [
    %{"account-id": 12035991, amount: 0.001, price: 11000 , symbol: "btcusdt", type: "sell-limit", source: "super-margin-api"},
    %{"account-id": 12035991, amount: 0.001, price: 11500 , symbol: "btcusdt", type: "sell-limit", source: "super-margin-api"}
  ],
  config
)

# Cancel multiple orders
ExHuobi.Margin.Rest.Order.bulk_cancel(%{"order-ids": [70664141188, 70664141185]}, config)
```

## Futures Exchange API
```elixir
config = %ExHuobi.Config{
  api_key: System.get_env("HUOBI_API_KEY"),
  api_secret: System.get_env("HUOBI_API_SECRET")
}
# Get account position
symbol = "BTC|ETH..."
ExHuobi.Futures.Rest.Account.get_position(symbol, config)

# Create new order
order = %{
        "contract_type" => "this_week",
        "direction" => "Buy",
        "lever_rate" => 5,
        "offset" => "open",
        "order_price_type" => "limit",
        "price" => 5000,
        "symbol" => "BTC",
        "volume" => 1
      }
ExHuobi.Futures.Rest.Order.create_order(order, config)

# Create multiple orders
orders = [
      %{
        "contract_type" => "this_week",
        "direction" => "Buy",
        "lever_rate" => 1,
        "offset" => "open",
        "order_price_type" => "limit",
        "price" => 5000,
        "symbol" => "BTC",
        "volume" => 1
      },
      %{
        "contract_type" => "next_week",
        "direction" => "Buy",
        "lever_rate" => 5,
        "offset" => "open",
        "order_price_type" => "limit",
        "price" => 5000,
        "symbol" => "BTC",
        "volume" => 1
      },
    ]


ExHuobi.Futures.Rest.Order.create_bulk_orders(orders, config)

# Cancel order

order_id = 1234567890

ExHuobi.Futures.Rest.Order.create_bulk_orders(order_id, config)

```
