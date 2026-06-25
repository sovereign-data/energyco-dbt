select contract_id, customer_id, tariff_code, start_date, end_date, status
from {{ ref('br_contract') }}
