--A view that counts the number of products or services with discounts each day. 
-- Generate random data for the discounted_items_count view
-- dummy data for 
INSERT INTO discount (discount_id, discount_type, discount_amount, discount_description, discount_start_date, discount_end_date)
SELECT 
    generate_series
    (12345, 'percentage coupon', 0.10, '50% off', '2024-03-01', '2024-03-15'),
    (65498, 'fixed coupon', 5.00, '$5 off', '2024-03-05', '2024-03-20');

-- dummy data into company_item
-- INSERT INTO company_item (company_id, item_id, is_discounted, discount_id)
-- VALUES
--     (1, 1, true, 12345),  
--     (1, 2, true, 65498),  
--     (2, 3, false, null); 

-- Generated random data into company_item 
--!!NOTE if this doesn't work, uncomment above two insert statements
INSERT INTO company_item (company_id, item_id, is_discounted, discount_id)
    SELECT
    floor(random() * 10) + 1 as company_id
    item_id, 
    random() < 0.5 as is_discounted, 
    discount_id
FROM
    (SELECT item_id FROM item ORDER BY random() LIMIT 5), 
    (SELECT discount_id FROM  discount ORDER BY random() LIMIT 5); 



-- counts number of products with discounts each day
CREATE VIEW daily_discount_count AS 
    SELECT 
        current_date AS date, COUNT (*) AS total_discounted_item,
        discounted_items.checkin_date, COUNT (*) AS total_discounted_item, 
        SUM(CASE WHEN prev_discounted_items = 0 THEN 1 ELSE 0 END) AS new_discounted_items
            FROM ( SELECT  ci_current.transaction_date AS current_date, COUNT(ci_current.item_id) AS prev_discounted_items
            JOIN company_item ci_prev ON ci_current.item_id = ci_prev.item_id AND ci_current.transaction_date = ci_prev.transaction_date + interval '1 day'
            WHERE ci_current.is_discounted = 'True'
            GROUP BY ci_current.transaction_date)
        GROUP BY current_date; 

        

-- sorted list of projects 
CREATE VIEW sorted_product_list AS
    SELECT item_id, item_name, item_description, item_price
    FROM item
    ORDER BY item_name;



--  -- -- -- -- -- -- V2 Views -- -- -- -- -- -- 

--  -- -- -- -- -- -- -- -- -- -- -- -- END DUMMY DATA INSERTION  -- -- -- -- -- -- -- -- -- -- -- -- 
--  -- NOTE - The insertion code in this section was authored by online tools
--  -- -- -- This data is intended to test the discount_history view only -- -- -- -- -- -- 
-- INSERT INTO discount (discount_id, discount_type, discount_amount, discount_description, discount_start_date, discount_end_date)
-- VALUES
--   (1, 'freebie', 0.00, 'Free trial', '2024-03-01', '2024-03-05'),  -- Applied from 2024-03-01 to 2024-03-05
--   (2, 'percentage coupon', 0.20, '20% off', '2024-03-03', '2024-03-08'),  -- Applied from 2024-03-03 to 2024-03-08
--   (3, 'fixed coupon', 10.00, 'Flat $10 discount', '2024-03-06', '2024-03-10'),  -- Applied from 2024-03-06 to 2024-03-10
--   (4, 'other', 0.00, 'Special offer', '2024-03-09', '2024-03-13');  -- Applied from 2024-03-09 to 2024-03-13

-- INSERT INTO company (company_id, company_name, company_contact, company_contact_phone_nbr, company_contact_email, url)
-- VALUES
--   (1, 'Company A', 'John Doe', '1234567890', 'john.doe@example.com', 'https://www.companya.com'),
--   (2, 'Company B', 'Jane Smith', '0987654321', 'jane.smith@example.com', 'https://www.companyb.com');

-- INSERT INTO item (item_id, item_type, item_name, item_description, item_price, item_picture)
-- VALUES
--   ('item1', 'service', 'Service 1', 'Description of Service 1', 50.00, 'service1.jpg'),
--   ('item2', 'service', 'Service 2', 'Description of Service 2', 75.00, 'service2.jpg'),
--   ('item3', 'product', 'Product 1', 'Description of Product 1', 25.00, 'product1.jpg'),
--   ('item4', 'product', 'Product 2', 'Description of Product 2', 35.00, 'product2.jpg'),
--   ('item5', 'service', 'Service 3', 'Description of Service 3', 60.00, 'service3.jpg'),
--   ('item6', 'service', 'Service 4', 'Description of Service 4', 80.00, 'service4.jpg'),
--   ('item7', 'product', 'Product 3', 'Description of Product 3', 30.00, 'product3.jpg'),
--   ('item8', 'product', 'Product 4', 'Description of Product 4', 40.00, 'product4.jpg');

-- INSERT INTO company_item (company_id, item_id, is_discounted, discount_id)
-- VALUES
--   (1, 'item1', true, 1),
--   (1, 'item2', true, 1),
--   (2, 'item3', true, 2),
--   (2, 'item4', true, 2),
--   (1, 'item5', true, 3),
--   (2, 'item6', true, 3),
--   (1, 'item7', true, 4),
--   (2, 'item8', true, 4);

--  -- -- -- -- -- -- -- -- -- -- -- -- END DUMMY DATA INSERTION  -- -- -- -- -- -- -- -- -- -- -- -- 

--  CREATE VIEW discount_history AS
--     -- Selecting old date range because it contains the entire set 
--     SELECT old.current_date AS "Date", COALESCE(old.currently_discounted,0) AS currently_discounted, COALESCE(new.newly_discounted,0) AS newly_discounted
--     FROM 
--     -- This table contains dates and the count of currently discounted items on that date
--     (SELECT DATE(discounts_date_range) AS current_date, COUNT(*) AS currently_discounted

--     FROM 
--         -- This table has all item & discount info 
--         (SELECT * FROM discount  AS d JOIN company_item AS c ON c.discount_id = d.discount_id) AS items_discounts

--         -- Adding the list of dates directly
--         CROSS JOIN 
--         -- Creates a table containing a list of dates from the earliest listed in discounts to the latest (incrementing by 1 day)
--         (SELECT * FROM 
--             generate_series(
--             (SELECT MIN(discount_start_date) FROM discount),
--             (SELECT MAX(discount_end_date) FROM discount),
--             '1 day'::interval
--             ) AS dates(discounts_date_range)
--         ) AS discounts_date_range

--     -- We want to count all those that are currently [current date] within the window of their discount
--     WHERE discounts_date_range BETWEEN items_discounts.discount_start_date AND items_discounts.discount_end_date
--     GROUP BY discounts_date_range
--     ) AS old

--     -- Left join because every day will have a running total, but not every day will have newly added discounts
--     LEFT JOIN 
--     -- This table contains a count of all newly discounted items per date
--     (SELECT DATE(discounts_date_range) AS discount_date, COUNT(items_discounts) AS newly_discounted

--         FROM 
--         -- This table has all item & discount info 
--         (SELECT * FROM discount AS d JOIN company_item AS c ON c.discount_id = d.discount_id) AS items_discounts
        
--         -- Adding the list of dates directly
--         CROSS JOIN 
--         -- Creates a table containing a list of dates from the earliest listed in discounts to the latest (incrementing by 1 day)
--         (SELECT * FROM 
--             generate_series(
--             (SELECT MIN(discount_start_date) FROM discount),
--             (SELECT MAX(discount_end_date) FROM discount),
--             '1 day'::interval
--             ) AS dates(discounts_date_range)
--         ) AS discounts_date_range

--         -- Newly discounted means today [current date] is the first day of the discount (assuming item cannot be part of 2 discounts at once)
--         -- and it did not slide directly from one discount to another (effectively extending its discount)
--         WHERE discounts_date_range = items_discounts.discount_start_date AND NOT discounts_date_range = items_discounts.discount_end_date
--         -- We want the total of new for each day
--         GROUP BY discounts_date_range
--     ) AS new 

--     -- Joining New & Current discount counts on the dates (so they line up)
--     ON new.discount_date = old.current_date
--     -- Ordering entire query by oldest to current date for clarity
--     ORDER BY old.current_date;

-- CREATE VIEW sorted_products AS
--     SELECT * FROM item
--     WHERE item_type = 'product'
--     ORDER BY item_name ASC;


-- SELECT * FROM sorted_products;
-- SELECT * FROM discount_history;