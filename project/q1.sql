WITH
    LatestArchiveOrderIDs AS (
        SELECT
            market_id,
            MAX(id) AS latest_archive_order_id
        FROM
            ArchiveOrders
        GROUP BY
            market_id
    )
SELECT
    lao.market_id AS market_id,
    ao.unit_price AS current_price
FROM
    LatestArchiveOrderIDs lao
    JOIN ArchiveOrders ao ON lao.latest_archive_order_id = ao.id;