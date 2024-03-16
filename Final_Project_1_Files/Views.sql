CREATE VIEW discount_history AS
    -- Selecting old date range because it contains the entire set 
    SELECT old.current_date AS "Date", COALESCE(old.currently_discounted,0) AS currently_discounted, COALESCE(new.newly_discounted,0) AS newly_discounted
    FROM 
    -- This table contains dates and the count of currently discounted items on that date
    (SELECT DATE(discounts_date_range) AS current_date, COUNT(*) AS currently_discounted

    FROM 
        -- This table has all item & discount info 
        (SELECT * FROM discount  AS d JOIN company_item AS c ON c.discount_id = d.discount_id) AS items_discounts

        -- Adding the list of dates directly
        CROSS JOIN 
        -- Creates a table containing a list of dates from the earliest listed in discounts to the latest (incrementing by 1 day)
        (SELECT * FROM 
            generate_series(
            (SELECT MIN(discount_start_date) FROM discount),
            (SELECT MAX(discount_end_date) FROM discount),
            '1 day'::interval
            ) AS dates(discounts_date_range)
        ) AS discounts_date_range

    -- We want to count all those that are currently [current date] within the window of their discount
    WHERE discounts_date_range BETWEEN items_discounts.discount_start_date AND items_discounts.discount_end_date
    GROUP BY discounts_date_range
    ) AS old

    -- Left join because every day will have a running total, but not every day will have newly added discounts
    LEFT JOIN 
    -- This table contains a count of all newly discounted items per date
    (SELECT DATE(discounts_date_range) AS discount_date, COUNT(items_discounts) AS newly_discounted

        FROM 
        -- This table has all item & discount info 
        (SELECT * FROM discount AS d JOIN company_item AS c ON c.discount_id = d.discount_id) AS items_discounts
        
        -- Adding the list of dates directly
        CROSS JOIN 
        -- Creates a table containing a list of dates from the earliest listed in discounts to the latest (incrementing by 1 day)
        (SELECT * FROM 
            generate_series(
            (SELECT MIN(discount_start_date) FROM discount),
            (SELECT MAX(discount_end_date) FROM discount),
            '1 day'::interval
            ) AS dates(discounts_date_range)
        ) AS discounts_date_range

        -- Newly discounted means today [current date] is the first day of the discount (assuming item cannot be part of 2 discounts at once)
        -- and it did not slide directly from one discount to another (effectively extending its discount)
        WHERE discounts_date_range = items_discounts.discount_start_date AND NOT discounts_date_range = items_discounts.discount_end_date
        -- We want the total of new for each day
        GROUP BY discounts_date_range
    ) AS new 

    -- Joining New & Current discount counts on the dates (so they line up)
    ON new.discount_date = old.current_date
    -- Ordering entire query by oldest to current date for clarity
    ORDER BY old.current_date;

CREATE VIEW sorted_products AS
    SELECT * FROM item
    WHERE item_type = 'product'
    ORDER BY item_name ASC;