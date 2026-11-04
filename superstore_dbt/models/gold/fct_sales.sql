{{ config(materialized='table') }}

WITH orders AS (

    SELECT *
    FROM {{ ref('int_orders_enriched') }}

),

sales_with_keys AS (

    SELECT
        p.product_key,
        c.customer_key,
        s.shipping_id,
        g.geo_id,
        o.date_id,
        o.order_id,
        o.sales,
        o.quantity,
        o.profit,
        o.discount

    FROM orders AS o

    LEFT JOIN {{ ref('dim_product') }} AS p
        ON
            o.product_id = p.product_id
            AND o.product_name = p.product_name

    LEFT JOIN {{ ref('dim_customer') }} AS c
        ON o.customer_id = c.customer_id

    LEFT JOIN {{ ref('dim_shipping') }} AS s
        ON o.ship_mode = s.ship_mode

    LEFT JOIN {{ ref('dim_geo') }} AS g
        ON
            o.country_region = g.country_region
            AND o.state = g.state
            AND o.city = g.city
            AND o.postal_code = g.postal_code
            AND o.region = g.region

),

aggregated_sales AS (

    SELECT
        product_key,
        customer_key,
        shipping_id,
        geo_id,
        date_id,

        SUM(sales) AS sales_amt,
        COUNT(DISTINCT order_id) AS orders_number,
        SUM(quantity) AS items_number,
        SUM(profit) AS profit_amt,

        ROUND(
            (SUM(profit) / NULLIF(SUM(sales), 0) * 100)::numeric,
            2
        ) AS profit_margin_pct,

        ROUND(
            (AVG(discount) * 100)::numeric,
            2
        ) AS avg_discount_pct,

        ROUND(
            (SUM(sales) / NULLIF(SUM(quantity), 0))::numeric,
            2
        ) AS avg_selling_price

    FROM sales_with_keys

    GROUP BY
        product_key,
        customer_key,
        shipping_id,
        geo_id,
        date_id

)

SELECT
    {{ dbt_utils.generate_surrogate_key([
        'product_key',
        'customer_key',
        'shipping_id',
        'geo_id',
        'date_id'
    ]) }} AS sales_key,

    product_key,
    customer_key,
    shipping_id,
    geo_id,
    date_id,

    sales_amt,
    orders_number,
    items_number,
    profit_amt,
    profit_margin_pct,
    avg_discount_pct,
    avg_selling_price,

    CURRENT_TIMESTAMP AS etl_timestamp

FROM aggregated_sales
