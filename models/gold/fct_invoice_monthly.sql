select
    customer_id,
    cast(date_trunc('month', reading_date) as date)  as invoice_month,
    sum(kwh)                           as kwh_billed,
    sum(cost_pence) / 100.0            as amount_pounds
from {{ ref('int_rated_intervals') }}
group by customer_id, cast(date_trunc('month', reading_date) as date)
