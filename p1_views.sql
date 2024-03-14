--A view that counts the number of products or services with discounts each day. 
-- Generate random data for the discounted_items_count view
-- dummy data for 
INSERT INTO discount (discount_id, discount_type, discount_amount, discount_description, discount_start_date, discount_end_date)
VALUES
    (12345, 'percentage coupon', 0.10, '50% off', '2024-03-01', '2024-03-15'),
    (65498, 'fixed coupon', 5.00, '$5 off', '2024-03-05', '2024-03-20');

-- dummy data into company_item
INSERT INTO company_item (company_id, item_id, is_discounted, discount_id)
VALUES
    (1, 1, true, 12345),  
    (1, 2, true, 65498),  
    (2, 3, false, null); 

-- Create a temporary table to store the series of dates
CREATE TABLE data_series AS 
    SELECT generate_series('2024-01-01' ::date, '2024-03-31' :: date, '1 day' :: interval) AS checkin_date;

-- counts number of products with discounts each day
CREATE VIEW daily_discount_count AS 
    SELECT 
        discounted_items.checkin_date, COUNT (*) AS total_discounted_item, 
        SUM(CASE WHEN discounted_items.prev_checkin_date IS NULL THEN 1 ELSE 0 END) AS new_discounted_items
            FROM ( SELECT ds.checkin_date, uc.item_id, LAG(uc.checkin_date) OVER (PARTITION BY uc.item_id ORDER BY uc.checkin_date) AS prev_checkin_date
            FROM data_series ds
            JOIN user_checkin AS uc ON ds.checkin_date = uc.checkin_date
            JOIN company_transaction_checkin c ON uc.checkin_id = c.checkin_id
            WHERE uc.discount_id IS NOT NULL) AS discounted_items
        GROUP BY ds.checkin_date;

DROP TABLE data_series; 
        

-- sorted list of projects 
CREATE VIEW sorted_product_list AS
    SELECT item_id, item_name, item_description, item_price
    FROM item
    ORDER BY item_name;
