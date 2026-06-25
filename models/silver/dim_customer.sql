select customer_id, lclid, full_name, segment, signup_date, pay_propensity, churn_flag
from {{ ref('br_customer') }}
