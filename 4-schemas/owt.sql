
{{ config(materialized = 'view', alias = 'owt', schema = 'marts') }}

WITH invoice_items as
(SELECT
STOCKCODE, DESCRIPTION, UNITPRICE,QUANTITY, INVOICENO FROM {{ref('items')}}),

invoices as
(SELECT CUSTOMERID, COUNTRY, INVOICEDATE, INVOICENO FROM  {{ref('invoices')}})

SELECT STOCKCODE, DESCRIPTION, UNITPRICE,QUANTITY, invoices.INVOICENO,
CUSTOMERID, COUNTRY, INVOICEDATE FROM invoices
LEFT JOIN invoice_items ON invoices.INVOICENO = invoice_items.INVOICENO
