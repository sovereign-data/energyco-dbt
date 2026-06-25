select reading_ts, lclid, kwh
from {{ ref('stg_meter_readings') }}
where kwh < 0
