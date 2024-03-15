
-- \copy services from 'YOUR_services.csv_PATH_HERE' delimiter ',' CSV HEADER;
-- \copy temp_user from 'YOUR_users.csv_PATH_HERE' delimiter ',' CSV HEADER;
-- \copy products from 'YOUR_products.csv_PATH_HERE' delimiter '|' CSV HEADER;

-- -- Deleting all entries w/ non-valid email addresses 
DELETE FROM temp_user WHERE NOT email ~* '^[A-Za-z0-9._+%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$';

-- Title case all fields 
UPDATE temp_user SET city = INITCAP(city), state = INITCAP(state), first_name = INITCAP(first_name),
last_name = INITCAP(last_name), street_address = INITCAP(street_address);
UPDATE products SET product_name = INITCAP(product_name), brand_company_name = INITCAP(brand_company_name), product_category = INITCAP(product_category);
UPDATE services SET service_name = INITCAP(service_name), company_name = INITCAP(company_name), service_category = INITCAP(service_category);

 -- Creates id for those w/o
UPDATE services SET service_id = CAST(100000000 + floor(random() * 900000000) AS bigint) WHERE (service_id <> '') IS NOT TRUE;
UPDATE products SET product_id = CAST(100000000 + floor(random() * 900000000) AS bigint) WHERE (product_id <> '') IS NOT TRUE;

--Inserting data from temp tables to original tables

INSERT INTO "user" (first_name, last_name, user_email, street_address, city, state, user_id)
SELECT first_name, last_name, email, street_address, city, state, CAST(100000000 + floor(random() * 900000000) AS bigint)
FROM temp_user; 

INSERT INTO company (company_id, company_name)
SELECT CAST(100000000 + floor(random() * 900000000) AS bigint), company_name
FROM services; 

INSERT INTO company (company_id, company_name)
SELECT CAST(100000000 + floor(random() * 900000000) AS bigint), brand_company_name
FROM products; 

INSERT INTO item (item_id, item_name)
SELECT DISTINCT(product_id), product_name
FROM products;

-- \i PATH_TO_p1_views_HERE
