select band, price_pence_per_kwh, applies_to
from {{ ref('br_tariff') }}
