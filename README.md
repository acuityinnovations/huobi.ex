# ExHuobi

Huobi API Client for Elixir

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ex_huobi` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_huobi, "~> 0.3.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ex_huobi](https://hexdocs.pm/ex_huobi).

## Config
```elixir
config = %{access_keys: ["XXX_HUOBI_API_KEY", "XXX_HUOBI_SECRET_KEY"]}
```

# Swap Rest API Usage
## Single API

### Create a new order
```elixir
ExHuobi.Swap.Rest.Order.create_order(
 %{ contract_code: "BTC-USD",
   client_order_id: 92233720366,
   volume: 1,
   price: 8000,
   direction: "Buy",
   lever_rate: 5,
   offset: "open",
   order_price_type: "limit"
}, config)
```

# Margin Rest API Usage

## Single API

### Get account info
```elixir
ExHuobi.Margin.Rest.Account.get(config)
```

### Create a new order
```elixir
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
```
### Cancel an order
```elixir
ExHuobi.Margin.Rest.Order.cancel(70662287304, config)
```

## Bulk API

### Create multiple orders
```elixir
ExHuobi.Margin.Rest.Order.bulk_create(%{"orders-data" =>
  [
    %{"account-id": 12035991, amount: 0.001, price: 11000 , symbol: "btcusdt", type: "sell-limit", source: "super-margin-api"},
    %{"account-id": 12035991, amount: 0.001, price: 11500 , symbol: "btcusdt", type: "sell-limit", source: "super-margin-api"}
  ]
  },
  config
)
```

### Cancel multiple orders
```elixir
ExHuobi.Margin.Rest.Order.bulk_cancel(%{"order-ids": [70664141188, 70664141185]}, config)
```

### Futures Exchange API
```elixir
config = %{access_keys: ["XXX_HUOBI_API_KEY", "XXX_HUOBI_SECRET_KEY"]}
# Get account position
```

### Get futures positions
```elixir
symbol = "BTC|ETH..."
ExHuobi.Futures.Rest.Account.get_position(symbol, config)
```

### Create new order
```elixir
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
```
### Create multiple orders
```elixir
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
```
### Cancel order
```elixir
order_id = 1234567890
ExHuobi.Futures.Rest.Order.cancel_order(order_id, config)

```
