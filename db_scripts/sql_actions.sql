-- Colorado State University - Global Campus
-- Database Concepts: WINTER16-D-8-MIS407-1
-- Student: Mark Cushman
-- Date: 2017-04-01

-- This script queries the database for the Please Be Kind Rewind video store application
-- This database will handle movie data, inventory data, customer data and invoices

USE pbkr;

-- REQUIREMENT: Using your selected RDBMS, develop and execute an SQL script file of DML SQL INSERT
-- statements to populate the tables using SQL INSERT statements for at least 5 rows of data per table.
-- This is a demonstration of a traditional way to insert data into a table.

INSERT INTO pbkr.CUSTOMER
	(customer_id,first_name,last_name,address,apartment,city,postal_code,state_province,country,phone) VALUES
	(1005, 'Mark','Cushman','111 Main Street',NULL,'Atlanta','30001','GA','US','1-(888)-555-5555'),
	(1006, 'Rocky','Racoon','222 Walnut Street',NULL,'Boulder','80001','CO','US','1-(888)-555-5555'),
	(1007, 'John','Lennon','333 High Street',NULL,'Miami','20001','FL','US','1-(888)-555-5555'),
	(1008, 'Paul','McCartney','444 Oak Street','23','Los Angeles','90001','CA','US','1-(888)-555-5555'),
	(1009, 'George','Harrison','555 Pine Street',NULL,'Phoenix','85001','AZ','US','1-(888)-555-5555');

-- 4. Delete a specific customer from the database. You can choose which row to delete.  Make sure
-- that you use the primary key column in your WHERE clause to affect only a specific row.
-- This delete command removes all the previously entered customers specifically by customer_id (PRIMARY KEY)

DELETE FROM pbkr.CUSTOMER where customer_id IN (1005, 1006, 1007, 1008, 1009);

-- 1. Retrieve all of the customers' names, account numbers, and addresses
-- (street and zip code only), sorted by account number
-- This query pulls this data with a limit of 25 due to the size of the table.  To retrieve ALL of the rows
-- remove the text 'LIMIT 25' from the end of the query

SELECT first_name, last_name, customer_id, address, postal_code FROM pbkr.CUSTOMER ORDER BY customer_id ASC LIMIT 25;

-- 2. Retrieve all of the DVDs rented in the last 30 days and sort in chronological rental date order
-- This query pulls back this data, again I am using a LIMIT operator to reduce the number of rows returned
-- By modifying the first select to be a SELECT COUNT(*), I can see the number of items returned would be 470

SELECT * FROM (
	SELECT
		i.customer_id, i.invoice_date,
		ii.inventory_id, ii.rental_price,
		iv.movie_id, iv.title, iv.item_type_id
	FROM pbkr.INVOICE i LEFT JOIN
		(SELECT * FROM pbkr.INVOICE_ITEM) ii ON i.invoice_id = ii.invoice_id LEFT JOIN
			(SELECT * from pbkr.INVENTORY_VW) iv ON ii.inventory_id = iv.inventory_id
	WHERE i.invoice_date BETWEEN
		(CURRENT_DATE() - INTERVAL 1 MONTH) AND CURRENT_DATE()
	ORDER BY invoice_date ASC
) AS RESULTS WHERE RESULTS.item_type_id = 2 LIMIT 50;

-- 3. Update a customer name to change their maiden names to married names. You can choose which row to update.
-- Make sure that you use the primary key column in your WHERE clause to affect only a specific row.
-- This command will update the customer's last name with the customer_id 1001 to the value "Som"
-- (this record is my name and the maiden name is my wife's)
UPDATE pbkr.CUSTOMER SET last_name = "Som" WHERE customer_id = 1001;
