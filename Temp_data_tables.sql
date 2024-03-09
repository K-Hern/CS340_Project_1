DROP TABLE temp_users;
DROP TABLE products;
DROP TABLE services;

CREATE TABLE services(
service_id TEXT,
service_name TEXT,
company_name TEXT,
service_category TEXT
);

CREATE TABLE temp_users(
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


\copy services from '/Users/kevinhernandezschool/Desktop/CS_340/Project_1/CS340_Project_1/files/services.csv' delimiter ',' CSV HEADER;
\copy temp_users from '/Users/kevinhernandezschool/Desktop/CS_340/Project_1/CS340_Project_1/files/users.csv' delimiter ',' CSV HEADER;
\copy products from '/Users/kevinhernandezschool/Desktop/CS_340/Project_1/CS340_Project_1/files/products.csv' delimiter '|' CSV HEADER;

