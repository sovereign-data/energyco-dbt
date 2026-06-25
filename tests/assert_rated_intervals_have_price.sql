select lclid, reading_ts
from {{ ref('int_rated_intervals') }}
where price_pence_per_kwh is null
