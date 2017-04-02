-- Colorado State University - Global Campus
-- Database Concepts: WINTER16-D-8-MIS407-1
-- Student: Mark Cushman
-- Date: 2017-04-01

-- This script populates the database for the Please Be Kind Rewind video store application
-- This database will handle movie data, inventory data, customer data and invoices

USE pbkr;

LOAD DATA LOCAL INFILE '../data/1_genre.csv' INTO TABLE pbkr.GENRE
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 LINES
(genre_id,description);

LOAD DATA LOCAL INFILE '../data/2_role.csv' INTO TABLE pbkr.ROLE
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 LINES
(role_id,description);

LOAD DATA LOCAL INFILE '../data/3_person.csv' INTO TABLE pbkr.PERSON
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 LINES
(person_id,name,birthday,description);

LOAD DATA LOCAL INFILE '../data/4_award_type.csv' INTO TABLE pbkr.AWARD_TYPE
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 LINES
(award_type_id,description);

LOAD DATA LOCAL INFILE '../data/5_movie.csv' INTO TABLE pbkr.MOVIE
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 LINES
(movie_id,title,running_length,release_date,description);

LOAD DATA LOCAL INFILE '../data/6_item_type.csv' INTO TABLE pbkr.ITEM_TYPE
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 LINES
(item_type_id,description);

LOAD DATA LOCAL INFILE '../data/7_distributor.csv' INTO TABLE pbkr.DISTRIBUTOR
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 LINES
(distributor_id,name);

LOAD DATA LOCAL INFILE '../data/8_customer.csv' INTO TABLE pbkr.CUSTOMER
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 LINES
(customer_id,first_name,last_name,address,apartment,city,postal_code,state_province,country,phone);

LOAD DATA LOCAL INFILE '../data/9_charge_type.csv' INTO TABLE pbkr.CHARGE_TYPE
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 LINES
(charge_type_id,description,default_cost);

LOAD DATA LOCAL INFILE '../data/10_discount.csv' INTO TABLE pbkr.DISCOUNT
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 LINES
(discount_id,movie_id,genre_id,start_date,end_date,discount_percent);

LOAD DATA LOCAL INFILE '../data/11_movie_genre.csv' INTO TABLE pbkr.MOVIE_GENRE
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 LINES
(movie_genre_id,genre_id,movie_id);

LOAD DATA LOCAL INFILE '../data/12_cast.csv' INTO TABLE pbkr.CAST
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 LINES
(cast_id,movie_id,role_id,person_id);

LOAD DATA LOCAL INFILE '../data/13_award.csv' INTO TABLE pbkr.AWARD
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 LINES
(award_id,award_type_id,person_id,movie_id,year);

LOAD DATA LOCAL INFILE '../data/14_catalog.csv' INTO TABLE pbkr.CATALOG
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 LINES
(catalog_id,movie_id,item_type_id,distributor_id,serial_number,wholesale_cost);

LOAD DATA LOCAL INFILE '../data/15_shipment.csv' INTO TABLE pbkr.SHIPMENT
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 LINES
(shipment_id,distributor_id,shipment_date);

LOAD DATA LOCAL INFILE '../data/16_shipment_item.csv' INTO TABLE pbkr.SHIPMENT_ITEM
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 LINES
(shipment_item_id,catalog_id,shipment_id,quantity,item_cost)

LOAD DATA LOCAL INFILE '../data/17_inventory.csv' INTO TABLE pbkr.INVENTORY
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 LINES
(inventory_id,shipment_item_id,rental_price)

-- INVOICE;

-- INVOICE_ITEM;

-- CHARGE;
