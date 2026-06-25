with hourly as (
    select
        s.lclid,
        s.reading_hour,
        case
            when month(s.reading_ts) in (12, 1, 2) then 'Winter'
            when month(s.reading_ts) in (3, 4, 5)  then 'Spring'
            when month(s.reading_ts) in (6, 7, 8)  then 'Summer'
            else 'Autumn'
        end as season,
        s.kwh
    from {{ ref('stg_meter_readings') }} s
    where s.kwh is not null
)
select
    c.segment,
    h.reading_hour,
    h.season,
    avg(h.kwh) as avg_kwh,
    count(*)   as n
from hourly h
join {{ ref('dim_customer') }} c
    on h.lclid = c.lclid
group by c.segment, h.reading_hour, h.season
