{{ config(materialized='table') }}

SELECT
    dbt_scd_id AS product_key,
    product_identity,
    product_id,
    product_name,
    category,
    sub_category,
    dbt_valid_from,
    dbt_valid_to
FROM {{ ref('snap_product') }}
