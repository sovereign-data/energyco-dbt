select
    cast(contract_id as varchar)    as contract_id,
    cast(customer_id as varchar)    as customer_id,
    cast(tariff_code as varchar)    as tariff_code,
    cast(start_date as date)        as start_date,
    cast(end_date as date)          as end_date,
    cast(status as varchar)         as status
from {{ raw_parquet('contract') }}
