{{ config(
    materialized = 'incremental',
    incremental_strategy = 'merge',
    unique_key = 'row_id'
) }}

SELECT *
FROM {{ ref('stg_orders') }}
