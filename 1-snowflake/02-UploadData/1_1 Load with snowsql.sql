-- login
snowsql -a up00895.eu-central-1 -u andreaskretz -w SMALLWAREHOUSE -d TESTDB;

-- set the warehouse manually
USE WAREHOUSE SMALLWAREHOUSE;

-- set database manually
USE DATABASE TESTDB;

-- select the schema
use schema ECOMMERCE;

-- create stage use the file format
create stage my_upload 
    file_format = ECOMMERCECSVFORMAT;

-- stage file
put file://\opt/snowflake/upload.csv @my_upload;

--copy staged file into table
copy into ECOMMERCE.DATA from @my_upload on_error = CONTINUE;

-- remove staged files, because copy always copies everything
remove @my_upload 

-- see your table is populated now
SHOW TABLES;

