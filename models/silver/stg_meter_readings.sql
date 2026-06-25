with dedup as (
    select
        lclid, std_or_tou, reading_ts, reading_ts_utc, kwh, acorn,
        row_number() over (partition by lclid, reading_ts order by reading_ts_utc) as rn
    from {{ ref('br_meter_readings') }}
)
select
    lclid,
    std_or_tou,
    reading_ts,
    reading_ts_utc,
    case when kwh < 0 then null else kwh end as kwh,
    acorn,
    cast(reading_ts as date)                 as reading_date,
    hour(reading_ts)                         as reading_hour,
    (hour(reading_ts) between 7 and 22)      as is_peak
from dedup
where rn = 1
