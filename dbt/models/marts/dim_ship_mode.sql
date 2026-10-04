{{ config(materialized='table') }}

with ship_modes as (
    select distinct ship_mode
    from {{ ref('stg_superstore') }}
    where ship_mode is not null
)

select
    row_number() over (order by ship_mode) as ship_mode_key,
    ship_mode
from ship_modes
