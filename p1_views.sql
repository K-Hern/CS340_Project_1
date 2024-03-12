--A view that counts the number of products or services with discounts each day. 
-- Generate random data for the discounted_items_count view

-- Create a temporary table to store the series of dates
CREATE TEMP TABLE dates_series AS
SELECT generate_series('2024-03-01'::date, '2024-03-31'::date, '1 day'::interval) AS checkin_date;

-- counts number of products with discounts each day
CREATE VIEW daily_discount_count AS
SELECT 
    ds.checkin_date,
    COUNT(*) AS total_discounted_items,
    SUM(CASE WHEN prev_checkin_date IS NULL THEN 1 ELSE 0 END) AS new_discounted_items
FROM (
    SELECT 
        ds.checkin_date,
        c.item_id,
        LAG(c.checkin_date) OVER (PARTITION BY c.item_id ORDER BY c.checkin_date) AS prev_checkin_date
    FROM dates_series ds
    JOIN user_checkin uc ON ds.checkin_date = uc.checkin_date
    JOIN company_transaction_checkin c ON uc.checkin_id = c.checkin_id
    WHERE c.discount_id IS NOT NULL
) AS discounted_items
GROUP BY ds.checkin_date;

DROP TABLE dates_series;


-- sorted list of projects 
CREATE VIEW sorted_product_list AS
SELECT item_id, item_name, item_description, item_price
FROM item
ORDER BY item_name;
