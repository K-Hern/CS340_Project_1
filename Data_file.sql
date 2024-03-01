
CREATE TABLE user (
    user_id INT,
    user_email VARCHAR(),
    password VARCHAR(),
    first_name VARCHAR(),
    last_name VARCHAR(),
    street_address VARCHAR(),
    city VARCHAR(),
    state VARCHAR(),
    zip_code VARCHAR()
);
---Auto updating id

CREATE TABLE user_interests (
    user_id INT,
    interest VARCHAR()
);

CREATE TABLE user_company_preference (
    user_id INT,
    preference_company_id INT
);

CREATE TABLE user_item_preference (
    user_id INT,
    item_id INT
);

CREATE TABLE user_location_preference (
    user_id INT,
    preference_location_city VARCHAR(),
    preference_location_state VARCHAR()
);

CREATE TABLE company (
    company_id INT,
    company_name VARCHAR(),
    company_contact VARCHAR(),
    company_contact_phone_nbr VARCHAR(),
    company_contact_email VARCHAR(),
    url VARCHAR()
);

CREATE TABLE company_location (
    company_id INT,
    location_id INT,
    street_address VARCHAR(),
    city VARCHAR(),
    state VARCHAR(),
    zip_code VARCHAR(),
    phone_nbr VARCHAR()
);

CREATE TABLE company_item (
    company_id INT,
    item_id INT,
    is_discounted BOOLEAN,
    discount_id INT
);

CREATE TABLE user_company_review (
    company_id INT,
    user_id INT,
    rating_score FLOAT,
    comments VARCHAR()
);
--.5 increment constraint for rating

CREATE TABLE item (
    item_id INT,
    item_type VARCHAR(),
    item_name VARCHAR(),
    item_description VARCHAR(),
    item_price MONEY,
    item_picture VARCHAR()
);

CREATE TABLE discount (
    discount_id INT,
    discount_type VARCHAR(),
    discount_amount MONEY,
    discount_description VARCHAR(),
    discount_start_date DATE,
    discount_end_date DATE
);

CREATE TABLE user_checkin (
    checkin_id INT,
    checkin_date DATE,
    user_id INT,
    company_id INT,
    item_id INT,
    discount_id INT
);

CREATE TABLE employee (
    employee_id INT,
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
);

CREATE TABLE company_transaction (
    transaction_id INT,
    transaction_date DATE,
    charge_type VARCHAR(),
    transaction_amount MONEY,
    surcharge MONEY,
    total_charge MONEY,
    is_paid BOOLEAN,
    paid_date DATE,
    company_id INT
);

CREATE TABLE company_transaction_checkin (
    transaction_id INT,
    checkin_id INT,
    checkin_charge MONEY
);
