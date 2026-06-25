{% macro raw_parquet(table_name) %}
    read_parquet('s3://energyco-raw/raw/' ~ table_name ~ '/')
{% endmacro %}
