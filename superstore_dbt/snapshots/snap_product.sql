{% snapshot snap_product %}

{{
    config(
        target_schema='dbt_dev',
        unique_key='product_identity',
        strategy='check',
        check_cols=[
            'product_name',
            'category',
            'sub_category'
        ]
    )
}}

    SELECT
        product_identity,
        product_id,
        product_name,
        category,
        sub_category
    FROM {{ ref('int_products_current') }}

{% endsnapshot %}
