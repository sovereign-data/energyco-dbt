select premise_id, customer_id, postcode_area, region
from {{ ref('br_premise') }}
