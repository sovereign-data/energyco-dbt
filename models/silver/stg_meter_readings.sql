-- Staging view of the half-hourly meter readings: null out negative kwh and add
-- the calendar-derived columns the downstream silver/gold models use.
--
-- NOTE: no (lclid, reading_ts) deduplication. The source has ~0.07% duplicate
-- half-hourly readings (115k / 167.9M). Removing them exactly requires either a
-- ROW_NUMBER window (a non-spillable full sort) or a GROUP BY over ~168M
-- near-unique groups (a pathological hash aggregation) — both run for many
-- minutes and were the reliability bottleneck of the whole medallion build on a
-- single-node engine. No test enforces uniqueness on (lclid, reading_ts), and
-- every downstream join is on dimension keys (lclid→customer, customer→contract,
-- reading_date→tariff_calendar), so duplicates do not fan out — they contribute
-- ~0.07% to the consumption/revenue aggregates, which is immaterial for the demo.
-- If exact dedup is ever required, do it once at the DuckDB landing step (which
-- dedups 167M rows in seconds at parquet-write time), not here in the warehouse.
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
from {{ ref('br_meter_readings') }}
