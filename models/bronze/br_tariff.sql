select
    cast(band as varchar)                 as band,
    cast(price_pence_per_kwh as double)   as price_pence_per_kwh,
    cast(applies_to as varchar)           as applies_to
from {{ raw_parquet('tariff') }}
