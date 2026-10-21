{{ config(
    materialized = 'incremental',
    incremental_strategy = 'delete+insert',
    unique_key = 'row_id'

) }}

SELECT *
FROM {{ ref('stg_orders') }}
