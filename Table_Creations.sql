--CREATE DATABASE cs_340_p1


CREATE TYPE charge_type AS ENUM ('annual fee', 'checkin fees');
CREATE TYPE discount_type AS ENUM ('freebie', 'percentage coupon', 'fixed coupon', 'other');
CREATE TYPE item_type AS ENUM ('service', 'product');


CREATE TABLE employee (
  employee_id INT NOT NULL,
  email VARCHAR(120),
  first_name VARCHAR(120),
  last_name VARCHAR(120),
  job_category VARCHAR(120),
  salary MONEY,
  start_date DATE,
  street_address VARCHAR(120),
  city VARCHAR(120),
  state VARCHAR(120),
  zip_code VARCHAR(120),
  PRIMARY KEY (employee_id)
  );
--NO REf


CREATE TABLE company (
  company_id INT NOT NULL,
  company_name VARCHAR(120),
  company_contact VARCHAR(120),
  company_contact_phone_nbr VARCHAR(120),
  company_contact_email VARCHAR(120),
  url VARCHAR(120),
  PRIMARY KEY (company_id)
  );
--NO REf




CREATE TABLE user (
  user_id INT NOT NULL,
  user_email VARCHAR(120),
  password VARCHAR(120),
  first_name VARCHAR(120),
  last_name VARCHAR(120),
  street_address VARCHAR(120),
  city VARCHAR(120),
  state VARCHAR(120),
  zip_code VARCHAR(120),
  PRIMARY KEY (user_id)
  );
--NO REf




CREATE TABLE item (
  item_id INT NOT NULL,
  item_type item_type,
  item_name VARCHAR(120),
  item_description VARCHAR(120),
  item_price MONEY,
  item_picture VARCHAR(120),
  PRIMARY KEY (item_id)
  );


CREATE TABLE discount (
  discount_id INT NOT NULL,
  discount_type discount_type,
  discount_amount MONEY,
  discount_description VARCHAR(120),
  discount_start_date DATE,
  discount_end_date DATE,
  PRIMARY KEY (discount_id)
  );
---Auto updating id
--NO REf




CREATE TABLE user_interests (
  user_id INT NOT NULL,
  interest VARCHAR(120) NOT NULL,
   PRIMARY KEY (user_id, interest),
   FOREIGN KEY (user_id),
  REFERENCES user(user_id)
  );




CREATE TABLE user_company_preference (
  user_id INT NOT NULL REFERENCES user(user_id),
  preference_company_id INT NOT NULL,
  PRIMARY KEY (user_id, preference_company_id),
  FOREIGN KEY (user_id,  preference_company_id),
  REFERENCES user(user_id),  company(company_id)
  );




CREATE TABLE user_item_preference (
  user_id INT NOT NULL,
  item_id INT NOT NULL,
  PRIMARY KEY (user_id, item_id),
  FOREIGN KEY (user_id, item_id),
  REFERENCES user(user_id), item(item_id)
  );




CREATE TABLE user_location_preference (
  user_id INT NOT NULL,
  preference_location_city VARCHAR(120) NOT NULL,
  preference_location_state VARCHAR(120) NOT NULL,
  PRIMARY KEY (user_id, preference_location_city, preference_location_state),
  FOREIGN KEY (user_id),
 REFERENCES user(user_id)
  );


CREATE TABLE company_location (
  company_id INT,
  location_id INT NOT NULL,
  street_address VARCHAR(120),
  city VARCHAR(120),
  state VARCHAR(120),
  zip_code VARCHAR(120),
  phone_nbr VARCHAR(120),
  PRIMARY KEY (location_id),
  FOREIGN KEY (company_id),
  REFERENCES company(company_id)
  );




CREATE TABLE company_item (
  company_id INT NOT NULL,
  item_id INT NOT NULL,
  is_discounted BOOLEAN,
  discount_id INT,
  PRIMARY KEY (company_id, item_id),
  FOREIGN KEY (company_id, item_id, discount_id),
  REFERENCES company(company_id), item(item_id), discount(discount_id)
  );




CREATE TABLE user_company_review (
  company_id INT NOT NULL,
  user_id INT NOT NULL,
  rating_score FLOAT,
  comments VARCHAR(120),
  PRIMARY KEY (company_id, user_id),
  FOREIGN KEY (company_id, user_id),
  REFERENCES company(company_id), user(user_id),
  CHECK (rating_score * 10) MOD 5  = 0
  );
--.5 increment constraint for rating




CREATE TABLE user_checkin (
   checkin_id INT NOT NULL,
   checkin_date DATE,
   user_id INT,
   company_id INT,
   item_id INT,
   discount_id INT,
   PRIMARY KEY (checkin_id),
   FOREIGN KEY (user_id, company_id, item_id, discount_id),
   REFERENCES user(user_id),
   REFERENCES company(company_id),
   REFERENCES item(item_id),
   REFERENCES discount(discount_id)
  );

CREATE TABLE company_transaction (
  transaction_id INT NOT NULL,
  transaction_date DATE,
  charge_type charge_type,
  transaction_amount MONEY,
  surcharge MONEY,
  total_charge MONEY (GENERATED ALWAYS AS (transaction_amount + surcharge) STORED),
  is_paid BOOLEAN,
  paid_date DATE,
  company_id INT,
  PRIMARY KEY (transaction_id),
  FOREIGN KEY (company_id),
  REFERENCES company(company_id)
  );


CREATE TABLE company_transaction_checkin (
  transaction_id INT NOT NULL,
  checkin_id INT,
  checkin_charge MONEY,
  PRIMARY KEY (transaction_id),
  FOREIGN KEY (transaction_id, checkin_id),
  REFERENCES company_transaction(transaction_id),
   REFERENCES user_checkin(checkin_id)
);
