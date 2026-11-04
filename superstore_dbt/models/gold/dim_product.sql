{{ config(
    materialized='table'
) }}

SELECT DISTINCT
    {{ dbt_utils.generate_surrogate_key([
        'product_id',
        'product_name'
    ]) }} AS product_key,

    product_id,
    product_name,
    category,
    sub_category
FROM {{ ref('int_orders_enriched') }}
