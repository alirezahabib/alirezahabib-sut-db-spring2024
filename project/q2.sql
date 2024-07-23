SELECT 
    w.currency, 
    o.unit_price, 
    SUM(CASE WHEN o.type = 'Buy' THEN ao.remained_number ELSE 0 END) AS total_buy_volume, 
    SUM(CASE WHEN o.type = 'Sell' THEN ao.remained_number ELSE 0 END) AS total_sell_volume
FROM ActiveOrders ao
JOIN ArchiveOrders o ON ao.archive_order_id = o.id
JOIN Wallets w ON o.wallet_id = w.id
GROUP BY (w.currency, o.unit_price);
