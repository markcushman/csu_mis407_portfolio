-- Colorado State University - Global Campus
-- Database Concepts: WINTER16-D-8-MIS407-1
-- Student: Mark Cushman
-- Date: 2017-04-01

-- This script creates the views for the Please Be Kind Rewind video store application
-- This database will handle movie data, inventory data, customer data and invoices

USE pbkr;

-- First drop the view
-- DROP VIEW IF EXISTS acme_crm.top_customers_vw;

-- Now create the view to show customers and their total spend
/* CREATE VIEW acme_crm.top_customers_vw AS
  SELECT first_name, last_name, address1, address2,
  city, postal_code, state_province, country, (
    SELECT SUM(order_total)
    FROM acme_crm.orders
    WHERE customers.id = customer_id
    GROUP BY customer_id
  ) AS total_spend
  FROM acme_crm.customers;
*/
