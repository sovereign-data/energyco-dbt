select
    i.customer_id,
    i.invoice_month,
    i.amount_pounds,
    round((1 - c.pay_propensity) * 90)              as days_to_pay,
    i.amount_pounds * (1 - c.pay_propensity)        as amount_outstanding,
    case
        when (1 - c.pay_propensity) * 90 <= 30 then '0-30'
        when (1 - c.pay_propensity) * 90 <= 60 then '31-60'
        when (1 - c.pay_propensity) * 90 <= 90 then '61-90'
        else '90+'
    end as aging_bucket
from {{ ref('fct_invoice_monthly') }} i
join {{ ref('dim_customer') }} c
    on i.customer_id = c.customer_id
