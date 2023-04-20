--to test number of invoices
{% test base_invoice_match(model, column_name) %}

with model_output as (
    select
        count({{ column_name }}) as count_invoices
    from {{ model }}
),
comparison_raw_data as (
    Select 
        count(*) 
    from (SELECT DISTINCT CUSTOMERID, COUNTRY, INVOICENO,INVOICEDATE FROM {{source('ecommerceraw', 'DATA')}})
)
select * from model_output where count_invoices != (select * from comparison_raw_data)

{% endtest %}