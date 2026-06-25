select customer_id, invoice_month, amount_pounds
from {{ ref('fct_invoice_monthly') }}
where amount_pounds < 0
