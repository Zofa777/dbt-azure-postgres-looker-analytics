{{ config(
    alias='orders_cleaned'
) }}

SELECT
    row_id,
    order_id,
    CASE
        WHEN quantity <= 0 THEN 1
        ELSE quantity
    END AS quantity
FROM {{ ref('stg_orders') }}
