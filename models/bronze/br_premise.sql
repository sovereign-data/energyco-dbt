select
    cast(premise_id as varchar)     as premise_id,
    cast(customer_id as varchar)    as customer_id,
    cast(postcode_area as varchar)  as postcode_area,
    cast(region as varchar)         as region
from {{ raw_parquet('premise') }}
