with stats as (
    select
        lclid,
        avg(kwh_total)    as avg_daily,
        stddev(kwh_total) as sd_daily
    from {{ ref('int_consumption_daily') }}
    group by lclid
)
select
    d.lclid,
    d.reading_date,
    d.kwh_total,
    (d.kwh_total = 0) as is_zero_usage,
    (s.sd_daily is not null and s.sd_daily > 0
        and d.kwh_total > s.avg_daily + 3 * s.sd_daily) as is_spike
from {{ ref('int_consumption_daily') }} d
join stats s
    on d.lclid = s.lclid
where d.kwh_total = 0
   or (s.sd_daily is not null and s.sd_daily > 0
        and d.kwh_total > s.avg_daily + 3 * s.sd_daily)
