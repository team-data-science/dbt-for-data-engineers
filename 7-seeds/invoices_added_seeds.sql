with invoices as
(SELECT DISTINCT CUSTOMERID, COUNTRY, INVOICEDATE, INVOICENO   FROM {{source('ecommerceraw', 'DATA')}}),

country as
(SELECT alpha2, en FROM {{ ref('countries') }} )

SELECT invoices.*, alpha2 as county_code FROM invoices
LEFT JOIN country on invoices.COUNTRY = country.en
