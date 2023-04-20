
{{ config(materialized = 'view') }}

with cte as
(SELECT STOCKCODE, DESCRIPTION, UNITPRICE,QUANTITY, INVOICENO,
CASE
WHEN CUSTOMERID is null THEN 'Cancelled'
ELSE 'Shipped' end status  FROM "TESTDB"."ECOMMERCE"."DATA")

SELECT * FROM cte
