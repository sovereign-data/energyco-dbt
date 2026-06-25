# energyco-dbt

dbt-trino medallion for the EnergyCo demo. Bronze reads the landed London
smart-meter Parquet from MinIO `energyco-raw` via SQE's `read_parquet()` TVF;
silver conforms + rates consumption against tariffs; gold builds operational and
financial marts. Sub-project 2a of the EnergyCo end-to-end demo.

## Layers
- **bronze/** — `read_parquet` of the six `energyco-raw` prefixes into Iceberg tables.
- **silver/** — typed/deduped readings, daily rollups, rated intervals, conformed dims.
- **gold/** — consumption, load profile, anomalies, invoices, revenue, AR aging.

## Standalone validation (no engine)
```bash
uv venv --python 3.12 .venv
uv pip install -e .
.venv/bin/dbt deps
TRINO_USER=x TRINO_PASSWORD=x .venv/bin/dbt parse --profiles-dir .
```

## Running on the platform
The Chameleon platform clones this repo, overwrites `profiles.yml` with a JWT
profile, sets `DBT_TARGET_CATALOG=ws_<slug>`, and runs `dbt build`. Prerequisites
(sub-project 2b): the landing tool has populated `energyco-raw`, and `energyco-raw`
is in SQE's `[storage.tvf].allowed_object_store_prefixes`.

> **2b validation note:** bronze uses `read_parquet('s3://energyco-raw/raw/<table>/')` (directory form — SQE rejects globs). The `meter_readings` prefix is Hive-partitioned (`year=YYYY/month=M/`); on the FIRST live `dbt build`, confirm SQE's `read_parquet` recurses into those partition subdirectories. If it does not, land `meter_readings` unpartitioned (sub-project 1 `--scale`) or point the source at the partition level. The flat dim prefixes (customer/premise/contract/tariff/tariff_calendar) are unaffected.
