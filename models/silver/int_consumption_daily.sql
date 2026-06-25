select
    lclid,
    reading_date,
    sum(kwh)                                          as kwh_total,
    sum(case when is_peak then kwh else 0 end)        as kwh_peak,
    sum(case when not is_peak then kwh else 0 end)    as kwh_offpeak,
    count(kwh)                                        as reading_count,
    cast(count(kwh) as double) / 48.0                 as completeness_ratio
from {{ ref('stg_meter_readings') }}
group by lclid, reading_date
