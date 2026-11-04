{{ config(
    materialized='view'
) }}

WITH enriched_orders AS (

    SELECT
        o.dwh_id,
        o.row_id,
        o.order_id,
        o.order_date,
        o.ship_date,
        o.ship_mode,

        o.customer_id,
        o.customer_name,
        o.segment,

        o.product_id,
        o.product_name,
        o.category,
        o.sub_category,

        o.country_region,
        o.city,
        o.state,
        o.postal_code,
        o.region,

        o.sales,
        o.discount,
        o.profit,
        c.quantity,

        cal.date_id,
        cal.year AS order_year,
        cal.month AS order_month,
        cal.month_name AS order_month_name,
        cal.quarter AS order_quarter,

        p.regional_manager,

        (r.order_id IS NOT NULL) AS is_returned,

        CURRENT_TIMESTAMP AS etl_timestamp

    FROM {{ ref('stg_orders') }} AS o

    LEFT JOIN {{ ref('int_orders_cleaned') }} AS c
        ON o.row_id = c.row_id

    LEFT JOIN {{ ref('calendar') }} AS cal
        ON o.order_date = cal.full_date

    LEFT JOIN {{ ref('stg_people') }} AS p
        ON o.region = p.region

    LEFT JOIN {{ ref('int_returns_deduplicated') }} AS r
        ON o.order_id = r.order_id

)

SELECT *
FROM enriched_orders
