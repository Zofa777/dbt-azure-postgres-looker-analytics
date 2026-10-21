{{ config(
    materialized='view',
    alias='stg_orders'
) }}

SELECT
    {{ dbt_utils.generate_surrogate_key(['row_id']) }} AS dwh_id,
    *,
    CURRENT_TIMESTAMP AS etl_timestamp

FROM {{ source('superstore', 'orders') }}
