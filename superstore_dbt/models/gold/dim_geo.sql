{{ config(materialized='table') }}

WITH geography AS (

    SELECT DISTINCT
        country_region,
        state,
        city,
        postal_code,
        region
    FROM {{ ref('int_orders_enriched') }}

)

SELECT
    {{ dbt_utils.generate_surrogate_key([
        'country_region',
        'state',
        'city',
        'postal_code',
        'region'
    ]) }} AS geo_id,

    country_region,
    state,
    city,
    postal_code,
    region,
    CURRENT_TIMESTAMP AS etl_timestamp

FROM geography
