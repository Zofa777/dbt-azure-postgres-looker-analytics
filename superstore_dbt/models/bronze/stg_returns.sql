{{ config(
    materialized = 'view',
    alias = 'stg_returns'
) }}

SELECT
    {{ dbt_utils.generate_surrogate_key(['order_id']) }} AS dwh_id,
    returned,
    order_id,
    CURRENT_TIMESTAMP AS etl_timestamp
FROM {{ source('superstore', 'returns') }}
