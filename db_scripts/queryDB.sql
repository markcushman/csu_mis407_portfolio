-- Colorado State University - Global Campus
-- Database Concepts: WINTER16-D-8-MIS407-1
-- Student: Mark Cushman
-- Date: 2017-04-01

-- This script queries the database for the Please Be Kind Rewind video store application
-- This database will handle movie data, inventory data, customer data and invoices

USE pbkr;

SELECT * from pbkr.GENRE;
SELECT * from pbkr.ROLE;
SELECT * from pbkr.DISCOUNT;
SELECT * from pbkr.AWARD_TYPE;
SELECT * from pbkr.ITEM_TYPE;
SELECT * from pbkr.DISTRIBUTOR;
SELECT * from pbkr.CHARGE_TYPE;


SELECT COUNT(*) from pbkr.PERSON;
SELECT * from pbkr.PERSON LIMIT 25;

SELECT COUNT(*) from pbkr.MOVIE;
SELECT * from pbkr.MOVIE LIMIT 25;

SELECT COUNT(*) from pbkr.CUSTOMER;
SELECT * from pbkr.CUSTOMER LIMIT 25;

SELECT COUNT(*) from pbkr.MOVIE_GENRE;
SELECT * from pbkr.MOVIE_GENRE LIMIT 25;

SELECT COUNT(*) from pbkr.CAST;
SELECT * from pbkr.CAST LIMIT 25;

SELECT COUNT(*) from pbkr.AWARD;
SELECT * from pbkr.AWARD LIMIT 25;

SELECT COUNT(*) from pbkr.CATALOG;
SELECT * from pbkr.CATALOG LIMIT 25;

SELECT COUNT(*) from pbkr.SHIPMENT;
SELECT * from pbkr.SHIPMENT LIMIT 25;

SELECT COUNT(*) from pbkr.SHIPMENT_ITEM;
SELECT * from pbkr.SHIPMENT_ITEM LIMIT 25;

SELECT COUNT(*) from pbkr.INVENTORY;
SELECT * from pbkr.INVENTORY LIMIT 25;

SELECT COUNT(*) from pbkr.INVOICE;
SELECT * from pbkr.INVOICE LIMIT 25;

SELECT COUNT(*) from pbkr.INVOICE_ITEM;
SELECT * from pbkr.INVOICE_ITEM LIMIT 25;

SELECT COUNT(*) from pbkr.CHARGE;
SELECT * from pbkr.CHARGE LIMIT 25;
