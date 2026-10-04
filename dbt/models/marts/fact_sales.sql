{{ config(materialized='table') }}

select
    s.row_id,
    s.order_id,
    order_date.date_key as order_date_key,
    ship_date.date_key as ship_date_key,
    customers.customer_key,
    products.product_key,
    ship_modes.ship_mode_key,
    s.sales,
    s.quantity,
    s.discount,
    s.profit
from {{ ref('stg_superstore') }} as s
left join {{ ref('dim_customers') }} as customers
    on s.customer_id = customers.customer_id
left join {{ ref('dim_products') }} as products
    on s.product_id = products.product_id
left join {{ ref('dim_ship_mode') }} as ship_modes
    on s.ship_mode = ship_modes.ship_mode
left join {{ ref('dim_date') }} as order_date
    on s.order_date = order_date.full_date
left join {{ ref('dim_date') }} as ship_date
    on s.ship_date = ship_date.full_date
