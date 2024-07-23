WITH TopSells AS (
    SELECT
        m.id AS market_id,
        ao.type AS type,
        ao.id AS order_id,
        ao.unit_price AS price,
        ROW_NUMBER() OVER (PARTITION BY m.id ORDER BY ao.unit_price DESC) AS rank
    FROM
        Markets m
    JOIN ArchiveOrders ao ON ao.market_id = m.id
    WHERE ao.type = 'Buy'
),
TopBuys AS (
    SELECT
        m.id AS market_id,
        ao.type AS type,
        ao.id AS order_id,
        ao.unit_price AS price,
        ROW_NUMBER() OVER (PARTITION BY m.id ORDER BY ao.unit_price ASC) AS rank
    FROM
        Markets m
    JOIN ArchiveOrders ao ON ao.market_id = m.id
    WHERE ao.type = 'Sell'
)
SELECT
    market_id,
    type,
    order_id,
    price
FROM TopSells
WHERE rank <= 10

UNION ALL

SELECT
    market_id,
    type,
    order_id,
    price
FROM TopBuys
WHERE rank <= 10
ORDER BY market_id, type, price DESC;
