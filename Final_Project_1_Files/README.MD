 -- Expected order of execution: 

 -- 1) Table_creations.sql
 -- 2) Temp_data_tables.sql
 -- 3) Data_cleaning.sql
 -- 4) Views.sql

 -- Instructions:
 -- You may run the entire set by entering "\i YOUR_PATH_TO_THIS_FILE" within your psql terminal after adjusting the paths below
 -- OR you may choose to run each file individually or linked by adjusting the file path found within each file

\i YOUR_PATH_TO_Table_creations.sql
\i YOUR_PATH_TO_Temp_data_tables.sql

\copy services from 'YOUR_PATH_TO_services.csv' delimiter ',' CSV HEADER;
\copy temp_user from 'YOUR_PATH_TO_users.csv' delimiter ',' CSV HEADER;
\copy products from 'YOUR_PATH_TO_products.csv' delimiter '|' CSV HEADER;

\i YOUR_PATH_TO_Data_cleaning.sql
\i YOUR_PATH_TO_Views.sql
