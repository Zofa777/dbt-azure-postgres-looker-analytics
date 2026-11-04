{{ config(
    materialized='table'
) }}

SELECT DISTINCT
    {{ dbt_utils.generate_surrogate_key(['customer_id']) }} AS customer_key,
    customer_id,
    customer_name

FROM {{ ref('int_orders_enriched') }}
