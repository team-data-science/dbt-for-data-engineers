import snowflake.snowpark.functions as f
from snowflake.snowpark.functions import col

def model(dbt, session):
    dbt.config(materialized = "table", alias = 'rfm_analysis', schema = 'marts')

    
    df_invoices = dbt.ref("invoices")
    df_items = dbt.ref("items")

    # Essentially, we get the latest invoice date per a customer and the number of invoices from the invoices table
    df_invoice = df_invoices.group_by(col("CUSTOMERID")).agg([f.max(col("INVOICEDATE")).alias("most_recent_order"), f.count("INVOICENO").alias("number_of_orders")])
    
    # Then, we calculate the total amount ordered from the items table:
    df_item_joined = df_items.join(df_invoices, df_items.INVOICENO == df_invoices.INVOICENO, join_type="left").drop(df_invoices.INVOICENO).drop(df_invoices.COUNTRY).drop(df_invoices.INVOICEDATE).with_column_renamed(df_items.INVOICENO, "INVOICENO")
    df_item = df_item_joined.group_by(col("CUSTOMERID")).agg([f.sum("UNITPRICE").alias("amount_ordered")])
    
    # In the last part of the code, we merge two datasets to identify the best customer based on their spending habits
    df_final = df_invoice.join(df_item, df_invoice.CUSTOMERID == df_item.CUSTOMERID, join_type="left").drop(df_invoice.CUSTOMERID).with_column_renamed(df_item.CUSTOMERID, "CUSTOMERID")

    return df_final