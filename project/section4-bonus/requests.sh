curl http://127.0.0.1:5000/api/otc/prices

curl https://127.0.0.1:5000/api/otc/prices

curl https://127.0.0.1:5000/api/otc/prices --insecure

curl http://127.0.0.1:5000/api/markets

curl -X POST http://127.0.0.1:5000/api/otc/orders \
    -H "Content-Type: application/json" \
    -d '{
        "userId": "12345",
        "currency": "BTC",
        "amount": 1.0,
        "price": 45000.00,
        "type": "buy"
    }'
{
  "message": "OTC order created successfully",
  "orderId": "6680585290f9c1289560c647",
  "status": "created"
}

curl http://127.0.0.1:5000/api/otc/orders

curl 'http://127.0.0.1:5000/api/otc/orders?userId=999'

curl 'http://127.0.0.1:5000/api/otc/orders?userId=12345'

curl -X DELETE 'http://127.0.0.1:5000/api/otc/orders'

curl -X DELETE 'http://127.0.0.1:5000/api/otc/orders?orderId=123'

curl -X DELETE 'http://127.0.0.1:5000/api/otc/orders?orderId=6680585290f9c1289560c647'

curl -X DELETE 'http://127.0.0.1:5000/api/otc/orders?orderId=999999999999999999999999'


curl -X POST http://127.0.0.1:5000/api/p2p/orders \
    -H "Content-Type: application/json" \
    -d '{
        "userId": "12345",
        "marketId": "btc_usd",
        "amount": 1.0,
        "price": 45000.00,
        "type": "buy"
    }'

curl -X DELETE 'http://127.0.0.1:5000/api/p2p/orders?orderId=123'

curl -X DELETE 'http://127.0.0.1:5000/api/p2p/orders?orderId=66805b9f374cd76950c2a42f'

curl -X DELETE 'http://127.0.0.1:5000/api/p2p/orders?orderId=999999999999999999999999'

curl 'http://127.0.0.1:5000/api/p2p/orders?userId=12345'

curl 'http://127.0.0.1:5000/api/p2p/orders?userId=12345&status=canceled'

curl 'http://127.0.0.1:5000/api/wallets?userId=12345'


curl -X POST http://127.0.0.1:5000/api/transactions \
  -H "Content-Type: application/json" \
  -d '{
    "fromUserId": "11121",
    "toUserId": "12345",
    "amount": 2.0,
    "currency": "BTC"
  }'


curl -X POST http://127.0.0.1:5000/api/transactions \
  -H "Content-Type: application/json" \
  -d '{
    "fromUserId": "11121",
    "toUserId": "12345",
    "amount": 100.0,
    "currency": "BTC"
  }'

curl 'http://127.0.0.1:5000/api/transactions/history'

curl 'http://127.0.0.1:5000/api/transactions/history?userId=12345'

curl 'http://127.0.0.1:5000/api/transactions/history?userId=12345&limit=2&offset=1'
