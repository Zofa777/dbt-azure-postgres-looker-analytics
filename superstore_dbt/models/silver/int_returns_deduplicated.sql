{{ config(
    materialized='view'
) }}

SELECT DISTINCT
    dwh_id,
    order_id,
    returned,
    CURRENT_TIMESTAMP AS etl_timestamp
FROM {{ ref('stg_returns') }}
