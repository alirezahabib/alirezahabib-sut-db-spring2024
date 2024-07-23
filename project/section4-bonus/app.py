from datetime import datetime, timezone

from bson.errors import InvalidId
from bson.objectid import ObjectId
from flask import Flask, request, jsonify
from pymongo import MongoClient

app = Flask(__name__)

# MongoDB setup
client = MongoClient('mongodb://localhost:27017/')
db = client['exchange']  # Database name


def log_event(event, details):
    db.logs.insert_one({
        "timestamp": datetime.now(timezone.utc),
        "event": event,
        "details": details
    })


def get_otc_prices():
    return list(db.otc_prices.find({}, {'_id': False}))


def get_markets():
    return list(db.markets.find({}, {'_id': False}))


def get_otc_orders(user_id):
    return list(db.otc_orders.find({'userId': user_id}, {'_id': False}))


def get_p2p_orders(user_id, status=None):
    query = {'userId': user_id}
    if status:
        query['status'] = status
    return list(db.p2p_orders.find(query, {'_id': False}))


def get_wallets(user_id):
    return list(db.wallets.find({'userId': user_id}, {'_id': False}))


def get_transaction_history(user_id, limit=10, offset=0):
    return list(db.transactions.find({'$or': [{'fromUserId': user_id}, {'toUserId': user_id}]})
                .skip(offset).limit(limit).sort('timestamp', -1))


@app.route('/api/otc/prices', methods=['GET'])
def otc_prices():
    prices = get_otc_prices()
    return jsonify(prices)


@app.route('/api/markets', methods=['GET'])
def markets():
    markets = get_markets()
    return jsonify(markets)


@app.route('/api/otc/orders', methods=['GET'])
def otc_orders():
    user_id = request.args.get('userId')
    if not user_id:
        return jsonify({"error": "userId is required"}), 400
    orders = get_otc_orders(user_id)
    return jsonify(orders)


@app.route('/api/p2p/orders', methods=['GET'])
def p2p_orders():
    user_id = request.args.get('userId')
    status = request.args.get('status')
    if not user_id:
        return jsonify({"error": "userId is required"}), 400
    orders = get_p2p_orders(user_id, status)
    return jsonify(orders)


@app.route('/api/otc/orders', methods=['POST'])
def set_otc_order():
    data = request.get_json()
    required_fields = ['userId', 'currency', 'amount', 'price', 'type']
    if not all(field in data for field in required_fields):
        return jsonify({"error": "Missing required fields"}), 400

    order = {
        "userId": data['userId'],
        "currency": data['currency'],
        "amount": data['amount'],
        "price": data['price'],
        "type": data['type'],
        "status": "pending",
        "timestamp": datetime.now(timezone.utc)
    }

    order_id = db.otc_orders.insert_one(order).inserted_id
    log_event("set_otc_order", order)

    return jsonify({"orderId": str(order_id), "status": "created", "message": "OTC order created successfully"})


@app.route('/api/p2p/orders', methods=['POST'])
def set_p2p_order():
    data = request.get_json()
    required_fields = ['userId', 'marketId', 'amount', 'price', 'type']
    if not all(field in data for field in required_fields):
        return jsonify({"error": "Missing required fields"}), 400

    order = {
        "userId": data['userId'],
        "marketId": data['marketId'],
        "amount": data['amount'],
        "price": data['price'],
        "type": data['type'],
        "status": "pending",
        "timestamp": datetime.now(timezone.utc)
    }

    order_id = db.p2p_orders.insert_one(order).inserted_id
    log_event("set_p2p_order", order)

    return jsonify({"orderId": str(order_id), "status": "created", "message": "P2P order created successfully"})


@app.route('/api/otc/orders', methods=['DELETE'])
def cancel_otc_order():
    order_id = request.args.get('orderId')
    if not order_id:
        return jsonify({"error": "orderId is required"}), 400

    try:
        result = db.otc_orders.update_one({'_id': ObjectId(order_id)}, {"$set": {"status": "canceled"}})
    except InvalidId:
        return jsonify({"error": "Invalid orderId format"}), 400

    if result.matched_count == 0:
        return jsonify({"error": "Order not found"}), 404

    log_event("cancel_otc_order", {"orderId": order_id})

    return jsonify({"orderId": order_id, "status": "cancelled", "message": "OTC order cancelled successfully"})


@app.route('/api/p2p/orders', methods=['DELETE'])
def cancel_p2p_order():
    order_id = request.args.get('orderId')
    if not order_id:
        return jsonify({"error": "orderId is required"}), 400

    try:
        result = db.p2p_orders.update_one({'_id': ObjectId(order_id)}, {"$set": {"status": "canceled"}})
    except InvalidId:
        return jsonify({"error": "Invalid orderId format"}), 400

    if result.matched_count == 0:
        return jsonify({"error": "Order not found"}), 404

    log_event("cancel_p2p_order", {"orderId": order_id})

    return jsonify({"orderId": order_id, "status": "cancelled", "message": "P2P order cancelled successfully"})


@app.route('/api/wallets', methods=['GET'])
def wallets():
    user_id = request.args.get('userId')
    if not user_id:
        return jsonify({"error": "userId is required"}), 400
    wallets = get_wallets(user_id)
    return jsonify(wallets)


@app.route('/api/transactions/history', methods=['GET'])
def transaction_history():
    user_id = request.args.get('userId')
    limit = int(request.args.get('limit', 10))
    offset = int(request.args.get('offset', 0))
    if not user_id:
        return jsonify({"error": "userId is required"}), 400
    transactions = get_transaction_history(user_id, limit, offset)
    for transaction in transactions:
        transaction["_id"] = str(transaction["_id"])
    return jsonify(transactions)


@app.route('/api/transactions', methods=['POST'])
def transfer_money():
    data = request.get_json()
    required_fields = ['fromUserId', 'toUserId', 'amount', 'currency']
    if not all(field in data for field in required_fields):
        return jsonify({"error": "Missing required fields"}), 400

    from_wallet = db.wallets.find_one({"userId": data['fromUserId'], "currency": data['currency']})
    to_wallet = db.wallets.find_one({"userId": data['toUserId'], "currency": data['currency']})

    if not from_wallet:
        return jsonify({"error": "Sender wallet not found"}), 404
    if not to_wallet:
        return jsonify({"error": "Receiver wallet not found"}), 404
    if from_wallet['balance'] < data['amount']:
        return jsonify({"error": "Insufficient funds"}), 400

    db.wallets.update_one({"userId": data['fromUserId'], "currency": data['currency']},
                          {"$inc": {"balance": -data['amount']}})
    db.wallets.update_one({"userId": data['toUserId'], "currency": data['currency']},
                          {"$inc": {"balance": data['amount']}})

    transaction = {
        "fromUserId": data['fromUserId'],
        "toUserId": data['toUserId'],
        "amount": data['amount'],
        "currency": data['currency'],
        "timestamp": datetime.now(timezone.utc)
    }

    transaction_id = db.transactions.insert_one(transaction).inserted_id
    log_event("transfer_money", transaction)

    return jsonify(
        {"transactionId": str(transaction_id), "status": "success", "message": "Money transferred successfully"})


if __name__ == '__main__':
    app.run(debug=True)
