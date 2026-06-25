select
    c.customer_id,
    c.segment,
    d.lclid,
    d.reading_date,
    d.kwh_total,
    d.kwh_peak,
    d.kwh_offpeak,
    d.completeness_ratio
from {{ ref('int_consumption_daily') }} d
join {{ ref('dim_customer') }} c
    on d.lclid = c.lclid
