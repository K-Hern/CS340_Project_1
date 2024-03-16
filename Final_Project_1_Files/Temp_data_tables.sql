-- DROP TABLE temp_users;
-- DROP TABLE products;
-- DROP TABLE services;

CREATE TABLE services(
service_id TEXT,
service_name TEXT,
company_name TEXT,
service_category TEXT
);

CREATE TABLE temp_user(
first_name TEXT,
last_name TEXT,
username TEXT,
email TEXT,
street_address TEXT,
city TEXT,
state TEXT
);


CREATE TABLE products (
product_id TEXT,
product_name TEXT,
brand_company_name TEXT,
product_category TEXT
);

-- \i YOUR_PATH_TO_Data_cleaning.sql_HERE


