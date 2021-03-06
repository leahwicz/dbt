
{{
    config(
        materialized="incremental",
        unique_key="id",
        cluster_by="id",
        partition_by={
            "field": "id",
            "data_type": "int64",
            "range": {
                "start": 1,
                "end": 10,
                "interval": 1
            }
        }
    )
}}


with data as (
    
    {% if not is_incremental() %}
    
        select 1 as id, cast('2020-01-01' as datetime) as date_time union all
        select 2 as id, cast('2020-01-01' as datetime) as date_time union all
        select 3 as id, cast('2020-01-01' as datetime) as date_time union all
        select 4 as id, cast('2020-01-01' as datetime) as date_time
    
    {% else %}
    
        select 1 as id, cast('2020-01-01' as datetime) as date_time union all
        select 2 as id, cast('2020-01-01' as datetime) as date_time union all
        select 3 as id, cast('2020-01-01' as datetime) as date_time union all
        select 4 as id, cast('2020-01-02' as datetime) as date_time union all
        select 5 as id, cast('2020-01-02' as datetime) as date_time union all
        select 6 as id, cast('2020-01-02' as datetime) as date_time
    
    {% endif %}

)

select * from data

{% if is_incremental() %}
where id >= (select max(id) from {{ this }})
{% endif %}
