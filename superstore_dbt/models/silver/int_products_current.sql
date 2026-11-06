{{ config(materialized='view') }}

WITH product_orders AS (

    SELECT
        o.row_id,
        o.product_id,
        o.product_name,
        o.category,
        o.sub_category,
        COALESCE(m.original_product_name, o.product_name)
            AS original_product_name

    FROM {{ ref('stg_orders') }} AS o

    LEFT JOIN {{ ref('product_identity_mapping') }} AS m
        ON
            o.product_id = m.product_id
            AND o.product_name = m.source_product_name

),

ranked_products AS (

    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY product_id, original_product_name
            ORDER BY row_id DESC
        ) AS rn

    FROM product_orders
    WHERE product_id IS NOT NULL

)

SELECT
    {{ dbt_utils.generate_surrogate_key([
        'product_id',
        'original_product_name'
    ]) }} AS product_identity,

    product_id,
    product_name,
    category,
    sub_category

FROM ranked_products
WHERE rn = 1
