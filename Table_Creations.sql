
CREATE TABLE user (
    user_id INT NOT NULL,
    user_email VARCHAR(),
    password VARCHAR(),
    first_name VARCHAR(),
    last_name VARCHAR(),
    street_address VARCHAR(),
    city VARCHAR(),
    state VARCHAR(),
    zip_code VARCHAR()
    PRIMARY KEY (user_id)
    );
---Auto updating id

CREATE TABLE user_interests (
    user_id INT NOT NULL,
    interest VARCHAR()
    PRIMARY KEY (user_id)
    );

CREATE TABLE user_company_preference (
    user_id INT NOT NULL,
    preference_company_id INT
    PRIMARY KEY (user_id)
    );

CREATE TABLE user_item_preference (
    user_id INT NOT NULL,
    item_id INT
    PRIMARY KEY (user_id)
    );

CREATE TABLE user_location_preference (
    user_id INT NOT NULL,
    preference_location_city VARCHAR(),
    preference_location_state VARCHAR()
    PRIMARY KEY (user_id)
    );

CREATE TABLE company (
    company_id INT NOT NULL,
    company_name VARCHAR(),
    company_contact VARCHAR(),
    company_contact_phone_nbr VARCHAR(),
    company_contact_email VARCHAR(),
    url VARCHAR()
    PRIMARY KEY (company_id)
    );

CREATE TABLE company_location (
    company_id INT NOT NULL,
    location_id INT,
    street_address VARCHAR(),
    city VARCHAR(),
    state VARCHAR(),
    zip_code VARCHAR(),
    phone_nbr VARCHAR()
    PRIMARY KEY (company_id)
    );

CREATE TABLE company_item (
    company_id INT NOT NULL,
    item_id INT,
    is_discounted BOOLEAN,
    discount_id INT
    PRIMARY KEY (company_id)
    );

CREATE TABLE user_company_review (
    company_id INT NOT NULL,
    user_id INT,
    rating_score FLOAT,
    comments VARCHAR()
    PRIMARY KEY (company_id)
    );
--.5 increment constraint for rating

CREATE TABLE item (
    item_id INT NOT NULL,
    item_type VARCHAR(),
    item_name VARCHAR(),
    item_description VARCHAR(),
    item_price MONEY,
    item_picture VARCHAR()
    PRIMARY KEY (item_id)
    );

CREATE TABLE discount (
    discount_id INT NOT NULL,
    discount_type VARCHAR(),
    discount_amount MONEY,
    discount_description VARCHAR(),
    discount_start_date DATE,
    discount_end_date DATE
    PRIMARY KEY (discount_id)
    );

CREATE TABLE user_checkin (
    checkin_id INT NOT NULL,
    checkin_date DATE,
    user_id INT,
    company_id INT,
    item_id INT,
    discount_id INT
    PRIMARY KEY (checkin_id)
    );

CREATE TABLE employee (
    employee_id INT NOT NULL,
    email VARCHAR(),
    first_name VARCHAR(),
    last_name VARCHAR(),
    job_category VARCHAR(),
    salary MONEY,
    start_date DATE,
    street_address VARCHAR(),
    city VARCHAR(),
    state VARCHAR(),
    zip_code VARCHAR()
    PRIMARY KEY (employee_id)
    );

CREATE TABLE company_transaction (
    transaction_id INT NOT NULL,
    transaction_date DATE,
    charge_type VARCHAR(),
    transaction_amount MONEY,
    surcharge MONEY,
    total_charge MONEY,
    is_paid BOOLEAN,
    paid_date DATE,
    company_id INT
    PRIMARY KEY (transaction_id)
    );

CREATE TABLE company_transaction_checkin (
    transaction_id INT NOT NULL,
    checkin_id INT,
    checkin_charge MONEY
    PRIMARY KEY (transaction_id)
    );

