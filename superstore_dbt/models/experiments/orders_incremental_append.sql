{{ config(
    materialized = 'incremental',
    incremental_strategy = 'append'
) }}

SELECT *
FROM {{ ref('stg_orders') }}

{% if is_incremental() %}
    WHERE row_id NOT IN (
        SELECT target_orders.row_id
        FROM {{ this }} AS target_orders
    )
{% endif %}
