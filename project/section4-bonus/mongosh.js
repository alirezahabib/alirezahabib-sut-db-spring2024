disableTelemetry()
use exchange

db.createCollection('otc_prices')
db.createCollection('markets')
db.createCollection('otc_orders')
db.createCollection('p2p_orders')
db.createCollection('wallets')
db.createCollection('transactions')
db.createCollection('logs')

db.otc_prices.insertMany([
    {currency: 'BTC', buy_price: 45000, sell_price: 45500},
    {currency: 'ETH', buy_price: 3000, sell_price: 3100}
])

db.markets.insertMany([
    {marketId: 'btc_usd', base_currency: 'BTC', quote_currency: 'USD', last_price: 45000, trading_volume: 1000},
    {marketId: 'eth_usd', base_currency: 'ETH', quote_currency: 'USD', last_price: 3000, trading_volume: 5000}
])


db.wallets.insertMany([
    {
        "_id": ObjectId(),
        "userId": "12345",
        "address": "1A2b3C4d5E6F7G8H9I0J",
        "balance": 10.5,
        "currency": "BTC"
    },
    {
        "_id": ObjectId(),
        "userId": "12345",
        "address": "2B3C4D5E6F7G8H9I0J1A",
        "balance": 25.0,
        "currency": "ETH"
    },
    {
        "_id": ObjectId(),
        "userId": "12345",
        "address": "3C4D5E6F7G8H9I0J1A2B",
        "balance": 50.0,
        "currency": "USDT"
    },
    {
        "_id": ObjectId(),
        "userId": "67890",
        "address": "J0I9H8G7F6E5D4C3B2A1",
        "balance": 5.75,
        "currency": "ETH"
    },
    {
        "_id": ObjectId(),
        "userId": "11121",
        "address": "K9L8M7N6O5P4Q3R2S1T",
        "balance": 20.0,
        "currency": "BTC"
    },
    {
        "_id": ObjectId(),
        "userId": "67890",
        "address": "E1D2C3B4A5F6G7H8I9J0",
        "balance": 12.5,
        "currency": "BTC"
    }
])
