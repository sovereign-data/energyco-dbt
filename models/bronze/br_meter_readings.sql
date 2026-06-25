select
    cast(lclid as varchar)            as lclid,
    cast(std_or_tou as varchar)       as std_or_tou,
    cast(reading_ts as timestamp(6))     as reading_ts,
    cast(reading_ts_utc as timestamp(6)) as reading_ts_utc,
    cast(kwh as double)               as kwh,
    cast(acorn as varchar)            as acorn
from {{ raw_parquet('meter_readings') }}
