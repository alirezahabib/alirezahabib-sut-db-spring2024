WITH LatestOrders AS (
    SELECT
        m.working_currency,
        MAX(ao.id) AS latest_archive_order_id
    FROM ArchiveOrders ao
    INNER JOIN Markets m ON ao.market_id = m.id
    WHERE m.base_currency = 'IRR'
    GROUP BY m.working_currency
),
LatestPrices AS (
    SELECT
        lo.working_currency,
        ao.unit_price AS current_price
    FROM
        LatestOrders lo
        JOIN ArchiveOrders ao ON lo.latest_archive_order_id = ao.id
),
LatestBalancePerWallet AS (
    SELECT
        w.id AS wallet_id,
        w.user_id,
        w.currency,
        bu.newBalance AS balance
    FROM
        Wallets w
        JOIN BalanceUpdates bu ON w.last_balance_update_number = bu.number
)
SELECT
    u.username,
    u.fullname,
    COALESCE(SUM(lb.balance * lp.current_price), 0) AS total_balance_rials
FROM
    LatestBalancePerWallet lb
    INNER JOIN Users u ON u.id = lb.user_id
    LEFT JOIN LatestPrices lp ON lb.currency = lp.working_currency
GROUP BY u.id;