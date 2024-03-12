--CREATE DATABASE cs_340_p1

-- DROP TABLE user_checkin;
-- DROP TABLE user_company_review;
-- DROP TABLE company_transaction_checkin;
-- DROP TABLE user_location_preference;
-- DROP TABLE user_item_preference;
-- DROP TABLE user_company_preference;
-- DROP TABLE user_interests;
-- DROP TABLE employee;
-- DROP TABLE company_transaction;
-- DROP TABLE discount;
-- DROP TABLE company_item;
-- DROP TABLE item;
-- DROP TABLE company_location;
-- DROP TABLE company;
-- DROP TABLE "user";

-- -- Data Cleaning Files
-- DROP TABLE temp_user;
-- DROP TABLE products;
-- DROP TABLE services;

DROP SCHEMA public CASCADE;
CREATE SCHEMA public;


CREATE TYPE charge_type AS ENUM ('annual fee', 'checkin fees');
CREATE TYPE discount_type AS ENUM ('freebie', 'percentage coupon', 'fixed coupon', 'other');
CREATE TYPE item_type AS ENUM ('service', 'product');

CREATE TABLE employee (
  employee_id INT NOT NULL,
  email VARCHAR(250),
  first_name VARCHAR(250),
  last_name VARCHAR(250),
  job_category VARCHAR(250),
  salary MONEY,
  start_date DATE,
  street_address VARCHAR(250),
  city VARCHAR(250),
  state VARCHAR(250),
  zip_code VARCHAR(250),
  PRIMARY KEY (employee_id)
  );
--No Ref

CREATE TABLE company (
  company_id INT NOT NULL, 
  company_name VARCHAR(250),
  company_contact VARCHAR(250),
  company_contact_phone_nbr VARCHAR(250),
  company_contact_email VARCHAR(250),
  url VARCHAR(250),
  PRIMARY KEY (company_id)
  );
--No Ref
--Address constraint URL

CREATE TABLE "user"(
  user_id INT NOT NULL,
  user_email VARCHAR(250)
  CONSTRAINT valid_email CHECK (user_email ~* '^[A-Za-z0-9._+%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$'),
  password VARCHAR(250),
  first_name VARCHAR(250),
  last_name VARCHAR(250),
  street_address VARCHAR(250),
  city VARCHAR(250),
  state VARCHAR(250),
  zip_code VARCHAR(250),
  PRIMARY KEY (user_id)
 );
--No Ref
--Address constraint email

CREATE TABLE item (
  item_id TEXT NOT NULL,
  item_type item_type,
  item_name TEXT,
  item_description VARCHAR(250),
  item_price MONEY,
  item_picture VARCHAR(250),
  PRIMARY KEY (item_id)
  );

CREATE TABLE discount (
  discount_id INT NOT NULL,
  discount_type discount_type,
  discount_amount MONEY,
  discount_description VARCHAR(250),
  discount_start_date DATE,
  discount_end_date DATE,
  PRIMARY KEY (discount_id)
  );
---Auto updating id
--No Ref

CREATE TABLE user_interests (
  user_id INT NOT NULL,
  interest VARCHAR(250) NOT NULL,
  PRIMARY KEY (user_id, interest),
  FOREIGN KEY (user_id)
  REFERENCES "user"(user_id)
);

CREATE TABLE user_company_preference (
  user_id INT NOT NULL REFERENCES "user"(user_id),
  preference_company_id INT NOT NULL,
  PRIMARY KEY (user_id, preference_company_id),
  FOREIGN KEY (user_id)
  REFERENCES "user"(user_id),
  FOREIGN KEY (preference_company_id)
  REFERENCES company(company_id)
);

CREATE TABLE user_item_preference (
  user_id INT NOT NULL,
  item_id TEXT NOT NULL,
  PRIMARY KEY (user_id, item_id),
  FOREIGN KEY (user_id)
  REFERENCES "user"(user_id),
  FOREIGN KEY (item_id)
  REFERENCES item(item_id)
);

CREATE TABLE user_location_preference (
  user_id INT NOT NULL,
  preference_location_city VARCHAR(250) NOT NULL,
  preference_location_state VARCHAR(250) NOT NULL,
  PRIMARY KEY (user_id, preference_location_city, preference_location_state),
  FOREIGN KEY (user_id)
  REFERENCES "user"(user_id)
);

CREATE TABLE company_location (
  company_id INT,
  location_id INT NOT NULL,
  street_address VARCHAR(250),
  city VARCHAR(250),
  state VARCHAR(250),
  zip_code VARCHAR(250),
  phone_nbr VARCHAR(250),
  PRIMARY KEY (location_id),
  FOREIGN KEY (company_id)
  REFERENCES company(company_id)
 );

CREATE TABLE company_item (
  company_id INT NOT NULL,
  item_id TEXT NOT NULL,
  is_discounted BOOLEAN,
  discount_id INT,
  PRIMARY KEY (company_id, item_id),
  FOREIGN KEY (company_id) REFERENCES company(company_id),
  FOREIGN KEY (item_id) REFERENCES item(item_id),
  FOREIGN KEY (discount_id) REFERENCES discount(discount_id)
);

CREATE TABLE user_company_review (
  company_id INT NOT NULL,
  user_id INT NOT NULL,
  rating_score NUMERIC CHECK(MOD((rating_score * 10.0),5.0) = 0),
  comments VARCHAR(250),
  PRIMARY KEY (company_id, user_id),
  FOREIGN KEY (company_id) REFERENCES company(company_id),
  FOREIGN KEY (user_id)REFERENCES "user"(user_id)
);

CREATE TABLE user_checkin (
  checkin_id INT NOT NULL,
  checkin_date DATE,
  user_id INT,
  company_id INT,
  item_id TEXT,
  discount_id INT,
  PRIMARY KEY (checkin_id),
  FOREIGN KEY (user_id) REFERENCES "user"(user_id),
  FOREIGN KEY (company_id)REFERENCES company(company_id),
  FOREIGN KEY (item_id)REFERENCES item(item_id),
  FOREIGN KEY (discount_id)REFERENCES discount(discount_id)
);

CREATE TABLE company_transaction (
  transaction_id INT NOT NULL,
  transaction_date DATE,
  charge_type charge_type,
  transaction_amount MONEY,
  surcharge MONEY,
  total_charge MONEY GENERATED ALWAYS AS (transaction_amount + surcharge) STORED,
  is_paid BOOLEAN,
  paid_date DATE,
  company_id INT,
  PRIMARY KEY (transaction_id),
  FOREIGN KEY (company_id)
  REFERENCES company(company_id)
);

CREATE TABLE company_transaction_checkin (
  transaction_id INT NOT NULL,
  checkin_id INT,
  checkin_charge MONEY,
  PRIMARY KEY (transaction_id),
  FOREIGN KEY (transaction_id)
  REFERENCES company_transaction(transaction_id),
  FOREIGN KEY (checkin_id)
  REFERENCES user_checkin(checkin_id)
);


 -- -- Item Archive Table -- -- 
CREATE TABLE item_archive (
  item_primary_key TEXT,
  item_name TEXT,
  old_value TEXT,
  new_value TEXT,
  update_stamp TIMESTAMP WITH TIME ZONE,
PRIMARY KEY (item_primary_key),
FOREIGN KEY (item_primary_key)
REFERENCES item(item_id)
);


 

----- Temp_data_tables

-- DROP TABLE temp_user;
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

 -- -- Archive Table Trigger
CREATE OR REPLACE FUNCTION archive_item() RETURNS TRIGGER AS
$BODY$
BEGIN
  INSERT INTO 
    item_archive(item_primary_key, item_name, old_value, new_value, update_stamp)
    VALUES (new.item_id, new.item_name, old.item_price, new.item_price, CURRENT_TIMESTAMP);

      RETURN new;
END;
$BODY$
LANGUAGE plpgsql;


CREATE TRIGGER add_item_record
BEFORE UPDATE ON item
FOR EACH ROW
EXECUTE PROCEDURE archive_item();


\copy services from '/Users/kevinhernandezschool/Desktop/CS_340/Project_1/CS340_Project_1/files/services.csv' delimiter ',' CSV HEADER;
\copy temp_user from '/Users/kevinhernandezschool/Desktop/CS_340/Project_1/CS340_Project_1/files/users.csv' delimiter ',' CSV HEADER;
\copy products from '/Users/kevinhernandezschool/Desktop/CS_340/Project_1/CS340_Project_1/files/products.csv' delimiter '|' CSV HEADER;


-- -- Deleting non-valid email addresses 
DELETE FROM temp_user WHERE NOT email ~* '^[A-Za-z0-9._+%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$';

-- Title case all fields 
UPDATE temp_user SET city = INITCAP(city), state = INITCAP(state), first_name = INITCAP(first_name),
last_name = INITCAP(last_name), street_address = INITCAP(street_address);
UPDATE products SET product_name = INITCAP(product_name), brand_company_name = INITCAP(brand_company_name), product_category = INITCAP(product_category);
UPDATE services SET service_name = INITCAP(service_name), company_name = INITCAP(company_name), service_category = INITCAP(service_category);

 -- Creates id for those w/o
UPDATE services SET service_id = CAST(100000000 + floor(random() * 900000000) AS bigint) WHERE (service_id <> '') IS NOT TRUE;
UPDATE products SET product_id = CAST(100000000 + floor(random() * 900000000) AS bigint) WHERE (product_id <> '') IS NOT TRUE;



-- -- -- BEGIN TESTING SECTION


-- -- Tests
-- -- Selects all invalid email address (checks if delete was functional)
-- SELECT * FROM temp_user WHERE NOT email ~* '^[A-Za-z0-9._+%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$';

--  -- Selects entries with empty vals
-- SELECT * FROM services WHERE (service_id <> '') IS NOT TRUE;
-- SELECT * FROM products WHERE (product_id <> '') IS NOT TRUE;

--- -- End Tests

-- SELECT * FROM products LIMIT 50;
-- SELECT * FROM services LIMIT 50;
-- SELECT * FROM temp_user LIMIT 50;

--Inserting data from temp tables

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


  -- -- END TEST SECTION

 -- -- BEGIN FINAL INDEX CREATION -- -- 

CREATE INDEX user_checkin_dates_index ON user_checkin (checkin_date);

CREATE INDEX user_interests_index ON user_interests USING HASH (interest);

CREATE INDEX company_location_city_index ON company_location USING HASH (city);

CREATE INDEX company_location_state_index ON company_location USING HASH (state);

CREATE INDEX company_discounted_items_index ON company_item USING HASH (is_discounted);

CREATE INDEX user_company_review_index ON user_company_review (rating_score);

CREATE INDEX item_price_index ON item (item_price);

CREATE INDEX discount_type_index ON discount USING HASH (discount_type);

CREATE INDEX company_transaction_date_index ON company_transaction (transaction_date);

CREATE INDEX company_transaction_charge_type_index ON company_transaction USING HASH (charge_type);


