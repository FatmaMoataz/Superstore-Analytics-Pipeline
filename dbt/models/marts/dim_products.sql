{{ config(materialized='table') }}

with products as (
    select
        product_id,
        min(product_name) as product_name,
        min(category)     as category,
        min(sub_category) as sub_category
    from {{ ref('stg_superstore') }}
    group by product_id
)

select
    row_number() over (order by product_id) as product_key,
    product_id,
    product_name,
    category,
    sub_category
from products