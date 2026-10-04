{{ config(materialized='table') }}

with customers as (
    select
        customer_id,
        min(customer_name) as customer_name,
        min(segment)       as segment,
        min(country)       as country,
        min(city)          as city,
        min(state)         as state,
        min(postal_code)   as postal_code,
        min(region)        as region
    from {{ ref('stg_superstore') }}
    group by customer_id
)

select
    row_number() over (order by customer_id) as customer_key,
    customer_id,
    customer_name,
    segment,
    country,
    city,
    state,
    postal_code,
    region
from customers