select
    cast("date" as date)    as tariff_date,
    cast(band as varchar)   as band
from {{ raw_parquet('tariff_calendar') }}
