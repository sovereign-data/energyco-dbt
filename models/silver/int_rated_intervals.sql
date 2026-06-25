with base as (
    select
        r.lclid,
        r.reading_ts,
        r.reading_date,
        r.kwh,
        c.customer_id,
        ctr.tariff_code,
        case
            when ctr.tariff_code = 'ToU' then coalesce(cal.band, 'Normal')
            else 'Std'
        end as applied_band
    from {{ ref('stg_meter_readings') }} r
    join {{ ref('dim_customer') }} c
        on r.lclid = c.lclid
    -- one active contract per customer (sub-project 1 guarantees 1:1); filter defends against fan-out
    join {{ ref('dim_contract') }} ctr
        on c.customer_id = ctr.customer_id
        and ctr.status = 'active'
    left join {{ ref('br_tariff_calendar') }} cal
        on ctr.tariff_code = 'ToU'
        and cal.tariff_date = r.reading_date
    where r.kwh is not null
)
select
    base.lclid,
    base.reading_ts,
    base.reading_date,
    base.kwh,
    base.customer_id,
    base.tariff_code,
    base.applied_band,
    p.price_pence_per_kwh,
    base.kwh * p.price_pence_per_kwh as cost_pence
from base
join {{ ref('dim_tariff') }} p
    on p.band = base.applied_band
