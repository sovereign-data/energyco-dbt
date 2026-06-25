select
    cast(customer_id as varchar)    as customer_id,
    cast(lclid as varchar)          as lclid,
    cast(full_name as varchar)      as full_name,
    cast(segment as varchar)        as segment,
    cast(signup_date as date)       as signup_date,
    cast(pay_propensity as double)  as pay_propensity,
    cast(churn_flag as boolean)     as churn_flag
from {{ raw_parquet('customer') }}
