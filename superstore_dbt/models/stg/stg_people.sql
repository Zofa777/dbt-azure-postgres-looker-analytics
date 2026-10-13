{{ config(
    materialized = 'view',
    alias = 'stg_people'
)}}

SELECT 
    {{ dbt_utils.generate_surrogate_key(['region'])}} AS dwh_id,
    regional_manager,
    region,
    CURRENT_TIMESTAMP as etl_timestamp
FROM {{ source('superstore', 'people')}}