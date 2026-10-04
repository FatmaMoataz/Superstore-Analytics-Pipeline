{{ config(materialized='table') }}

with dates as (
    select order_date as full_date from {{ ref('stg_superstore') }}
    union
    select ship_date as full_date from {{ ref('stg_superstore') }}
)

select
    cast(strftime(full_date, '%Y%m%d') as integer) as date_key,
    full_date,
    cast(strftime(full_date, '%Y') as integer) as year,
    cast(strftime(full_date, '%m') as integer) as month,
    cast(strftime(full_date, '%d') as integer) as day,
    strftime(full_date, '%B') as month_name,
    strftime(full_date, '%A') as day_name,
    cast(strftime(full_date, '%w') as integer) as day_of_week
from dates
where full_date is not null
