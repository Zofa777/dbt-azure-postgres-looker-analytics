{{ config(
    materialized='table'
) }}

WITH shipping AS (
    SELECT DISTINCT ship_mode
    FROM {{ ref('int_orders_enriched') }}
    WHERE ship_mode IS NOT NULL
)

SELECT
    {{ dbt_utils.generate_surrogate_key(['ship_mode']) }} AS shipping_id,
    ship_mode,
    CURRENT_TIMESTAMP AS etl_timestamp
FROM shipping
