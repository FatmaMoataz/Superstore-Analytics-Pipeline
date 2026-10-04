{{ config(materialized='view') }}

select
    try_cast("Row ID" as integer) as row_id,
    cast("Order ID" as varchar) as order_id,
    try_cast("Order Date" as date) as order_date,
    try_cast("Ship Date" as date) as ship_date,
    trim(cast("Ship Mode" as varchar)) as ship_mode,
    cast("Customer ID" as varchar) as customer_id,
    trim(cast("Customer Name" as varchar)) as customer_name,
    trim(cast("Segment" as varchar)) as segment,
    trim(cast("Country" as varchar)) as country,
    trim(cast("City" as varchar)) as city,
    trim(cast("State" as varchar)) as state,
    cast("Postal Code" as varchar) as postal_code,
    trim(cast("Region" as varchar)) as region,
    cast("Product ID" as varchar) as product_id,
    trim(cast("Category" as varchar)) as category,
    trim(cast("Sub-Category" as varchar)) as sub_category,
    trim(cast("Product Name" as varchar)) as product_name,
    try_cast("Sales" as double) as sales,
    try_cast("Quantity" as integer) as quantity,
    try_cast("Discount" as double) as discount,
    try_cast("Profit" as double) as profit
from {{ source('ods', 'raw_superstore') }}
