SELECT
    row_id,
    order_id,
    quantity
FROM {{ ref('stg_orders') }}
WHERE
    quantity IS NULL
    OR quantity <= 0
