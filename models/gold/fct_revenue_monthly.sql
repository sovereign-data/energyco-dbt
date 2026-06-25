select
    i.invoice_month,
    c.segment,
    ctr.tariff_code,
    sum(i.amount_pounds)          as revenue_pounds,
    count(distinct i.customer_id) as customers
from {{ ref('fct_invoice_monthly') }} i
join {{ ref('dim_customer') }} c
    on i.customer_id = c.customer_id
join {{ ref('dim_contract') }} ctr
    on i.customer_id = ctr.customer_id
group by i.invoice_month, c.segment, ctr.tariff_code
