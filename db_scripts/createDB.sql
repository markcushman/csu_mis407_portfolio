-- Colorado State University - Global Campus
-- Database Concepts: WINTER16-D-8-MIS407-1
-- Student: Mark Cushman
-- Date: 2017-04-01

-- This script creates the database for the Please Be Kind Rewind video store application
-- This database will handle movie data, inventory data, customer data and invoices

-- First, create the database if it does not exist and switch to that db
-- We will continue to use fully qualified table names for good style
DROP DATABASE IF EXISTS pbkr;
CREATE DATABASE IF NOT EXISTS pbkr;
USE pbkr;

-- We drop tables if they exist so we can re-create them
DROP TABLE IF EXISTS pbkr.GENRE;
CREATE TABLE pbkr.GENRE (
  /* 1 GENRE is a table to store genre descriptions */
  genre_id INT NOT NULL, /* Unique ID for GENRE */
  description VARCHAR(30) NOT NULL, /* Description of GENRE */
  PRIMARY KEY (genre_id)
);

DROP TABLE IF EXISTS pbkr.ROLE;
CREATE TABLE pbkr.ROLE (
  /* 2 ROLE is a table to store role descriptions */
  role_id INT NOT NULL, /* Unique ID for ROLE */
  description VARCHAR(30) NOT NULL, /* Description of ROLE */
  PRIMARY KEY (role_id)
);

DROP TABLE IF EXISTS pbkr.PERSON;
CREATE TABLE pbkr.PERSON (
  /* 3 PERSON is a table to store actors and directors */
  person_id INT NOT NULL, /* Unique ID for PERSON */
  name VARCHAR(60) NOT NULL, /* Name of PERSON */
  birthday DATETIME NULL, /* Birthday of PERSON */
  description TEXT NULL, /* Description of PERSON */
  PRIMARY KEY (person_id)
);

DROP TABLE IF EXISTS pbkr.AWARD_TYPE;
CREATE TABLE pbkr.AWARD_TYPE (
  /* 4 AWARD_TYPE is a table to store award descriptions */
  award_type_id INT NOT NULL, /* Unique ID for AWARD_TYPE */
  description VARCHAR(30) NOT NULL, /* Description of AWARD_TYPE */
  PRIMARY KEY (award_type_id)
);

DROP TABLE IF EXISTS pbkr.MOVIE;
CREATE TABLE pbkr.MOVIE (
  /* 5 MOVIE is the base movie table */
  movie_id INT NOT NULL, /* Unique ID for MOVIE */
  title VARCHAR(60) NOT NULL, /* Title of MOVIE */
  running_length INT NOT NULL, /* Running Length (minutes) of MOVIE */
  release_date DATETIME NOT NULL, /* The date the MOVIE was released */
  description TEXT, /* Description of MOVIE */
  PRIMARY KEY (movie_id)
);

DROP TABLE IF EXISTS pbkr.ITEM_TYPE;
CREATE TABLE pbkr.ITEM_TYPE (
  /* 6 ITEM_TYPE is a table to store descriptions of items */
  item_type_id INT NOT NULL, /* Unique ID for ITEM_TYPE */
  description VARCHAR(30) NOT NULL, /* Description of ITEM_TYPE */
  PRIMARY KEY (item_type_id)
);

DROP TABLE IF EXISTS pbkr.DISTRIBUTOR;
CREATE TABLE pbkr.DISTRIBUTOR (
  /* 7 DISTRIBUTOR is a table storing distributor names */
  distributor_id INT NOT NULL, /* Unique ID for DISTRIBUTOR */
  name VARCHAR(30) NOT NULL, /* Name of DISTRIBUTOR */
  PRIMARY KEY (distributor_id)
);

DROP TABLE IF EXISTS pbkr.CUSTOMER;
CREATE TABLE pbkr.CUSTOMER (
  /* 8 CUSTOMER is the main customer table */
  customer_id INT NOT NULL, /* Unique ID for CUSTOMER */
  first_name VARCHAR(30) NOT NULL, /* First Name of CUSTOMER */
  last_name VARCHAR(30) NOT NULL, /* Last Name of CUSTOMER */
  address VARCHAR(30) NOT NULL, /* Address of CUSTOMER */
  apartment VARCHAR(30), /* Apartment/unit # of CUSTOMER */
  city VARCHAR(30) NOT NULL, /* City of CUSTOMER */
  postal_code VARCHAR(6) NOT NULL, /* Postal Code of CUSTOMER */
  state_province VARCHAR(3) NOT NULL, /* State or province of CUSTOMER */
  country VARCHAR(2) NOT NULL, /* Country code of CUSTOMER */
  phone VARCHAR(30) NOT NULL, /* Phone number of CUSTOMER */
  PRIMARY KEY (customer_id)
);

DROP TABLE IF EXISTS pbkr.CHARGE_TYPE;
CREATE TABLE pbkr.CHARGE_TYPE (
  /* 9 CHARGE_TYPE is a table storing charge descriptions */
  charge_type_id INT NOT NULL, /* Unique ID for CHARGE_TYPE */
  description VARCHAR(30) NOT NULL, /* CHARGE_TYPE description */
  default_cost DECIMAL(9,2), /* Default cost for the type of charge */
  PRIMARY KEY (charge_type_id)
);

DROP TABLE IF EXISTS pbkr.DISCOUNT;
CREATE TABLE pbkr.DISCOUNT (
  /* 10 DISCOUNT is a table storing promotions */
  discount_id INT NOT NULL, /* Unique ID for DISCOUNT */
  movie_id INT NULL, /* ID of the MOVIE if this discount applies to just one movie */
  genre_id INT NULL, /* ID of the GENRE if this discount applies to a genre of movies */
  start_date DATETIME NOT NULL, /* Starting date when the discount applies */
  end_date DATETIME NOT NULL, /* Ending date of the discount period */
  discount_percent INT NOT NULL, /* Percentage removed from retail price during discount period */
  PRIMARY KEY (discount_id),
  FOREIGN KEY (movie_id) REFERENCES pbkr.MOVIE(movie_id),
  FOREIGN KEY (genre_id) REFERENCES pbkr.GENRE(genre_id)
);

DROP TABLE IF EXISTS pbkr.MOVIE_GENRE;
CREATE TABLE pbkr.MOVIE_GENRE (
  /* 11 MOVIE_GENRE is a table that links a genre to a movie */
  movie_genre_id INT NOT NULL, /* Unique ID for MOVIE_GENRE */
  genre_id INT NOT NULL, /* ID of the GENRE for the movie in movie_id */
  movie_id INT NOT NULL, /* ID of the MOVIE that the genre applies to */
  PRIMARY KEY (movie_genre_id),
  FOREIGN KEY (genre_id) REFERENCES pbkr.GENRE(genre_id),
  FOREIGN KEY (movie_id) REFERENCES pbkr.MOVIE(movie_id)
);

DROP TABLE IF EXISTS pbkr.CAST;
CREATE TABLE pbkr.CAST (
  /* 12 CAST is a table that links a PERSON to a MOVIE and ROLE */
  cast_id INT NOT NULL, /* Unique ID for CAST */
  movie_id INT NOT NULL, /* ID of the MOVIE they particpated in */
  role_id INT NOT NULL, /* ID of the ROLE they had (1 - Director, 2 - Actor) */
  person_id INT NOT NULL, /* ID of the PERSON */
  PRIMARY KEY (cast_id),
  FOREIGN KEY (movie_id) REFERENCES pbkr.MOVIE(movie_id),
  FOREIGN KEY (role_id) REFERENCES pbkr.ROLE(role_id),
  FOREIGN KEY (person_id) REFERENCES pbkr.PERSON(person_id)
);

DROP TABLE IF EXISTS pbkr.AWARD;
CREATE TABLE pbkr.AWARD (
  /* 13 AWARD is a table that links an AWARD_TYPE to a MOVIE and maybe a PERSON */
  award_id INT NOT NULL, /* Unique ID for AWARD */
  award_type_id INT NOT NULL, /* ID of the AWARD_TYPE */
  person_id INT NULL, /* ID of the PERSON who won the award */
  movie_id INT NOT NULL, /* ID of the MOVIE the award applies to */
  year YEAR NOT NULL, /* Year the award was given */
  PRIMARY KEY (award_id),
  FOREIGN KEY (award_type_id) REFERENCES pbkr.AWARD_TYPE(award_type_id),
  FOREIGN KEY (person_id) REFERENCES pbkr.PERSON(person_id),
  FOREIGN KEY (movie_id) REFERENCES pbkr.MOVIE(movie_id)
);

DROP TABLE IF EXISTS pbkr.CATALOG;
CREATE TABLE pbkr.CATALOG (
  /* 14 CATALOG is a table containing many DISTRIBUTORs catalogs of movies */
  catalog_id INT NOT NULL, /* Unique ID for CATALOG */
  movie_id INT NOT NULL, /* ID of the MOVIE this catalog entry is for */
  item_type_id INT NOT NULL, /* FK ID of the ITEM_TYPE for the type (1 - VHS, 2 - DVD) */
  distributor_id INT NOT NULL, /* FK ID of the DISTRIBUTOR this catalog entry is from */
  serial_number VARCHAR(30) NOT NULL, /* Serial number for this entry (unique only per distributor) */
  wholesale_cost DECIMAL(9,2) NOT NULL, /* Wholesale cost of the video */
  PRIMARY KEY (catalog_id),
  FOREIGN KEY (movie_id) REFERENCES pbkr.MOVIE(movie_id)
);

DROP TABLE IF EXISTS pbkr.SHIPMENT;
CREATE TABLE pbkr.SHIPMENT (
  /* 15 SHIPMENT is a table representing a shipment of movies */
  shipment_id INT NOT NULL, /* Unique ID for SHIPMENT */
  distributor_id INT NOT NULL, /* ID of the DISTRIBUTOR this shipment is from */
  shipment_date DATETIME NOT NULL, /* Date this shipment shipped */
  PRIMARY KEY (shipment_id),
  FOREIGN KEY (distributor_id) REFERENCES pbkr.DISTRIBUTOR(distributor_id)
);

DROP TABLE IF EXISTS pbkr.SHIPMENT_ITEM;
CREATE TABLE pbkr.SHIPMENT_ITEM (
  /* 16 SHIPMENT_ITEM is a table containing line items of shipments */
  shipment_item_id INT NOT NULL, /* Unique ID for SHIPMENT_ITEM */
  catalog_id INT NOT NULL, /* ID of the CATALOG of the video that was shipped */
  shipment_id INT NOT NULL, /* ID of the SHIPMENT this item was included in */
  quantity INT NOT NULL, /* Quanitity of the videos included in this shipment */
  item_cost DECIMAL(9,2) NOT NULL, /* Cost of the video in this shipment (determined by volume) */
  PRIMARY KEY (shipment_item_id),
  FOREIGN KEY (catalog_id) REFERENCES pbkr.CATALOG(catalog_id),
  FOREIGN KEY (shipment_id) REFERENCES pbkr.SHIPMENT(shipment_id)
);

DROP TABLE IF EXISTS pbkr.INVENTORY;
CREATE TABLE pbkr.INVENTORY (
  /* 17 INVENTORY is a table containing the store's movie inventory */
  inventory_id INT NOT NULL, /* Unique ID for INVENTORY */
  shipment_item_id INT NOT NULL, /* ID of the SHIPMENT that this inventory item shipped with */
  rental_price DECIMAL(9,2) NOT NULL, /* Rental price */
  PRIMARY KEY (inventory_id),
  FOREIGN KEY (shipment_item_id) REFERENCES pbkr.SHIPMENT_ITEM(shipment_item_id)
);

DROP TABLE IF EXISTS pbkr.INVOICE;
CREATE TABLE pbkr.INVOICE (
  /* 18 INVOICE is a table containing the main invoices for CUSTOMERs */
  invoice_id INT NOT NULL, /* Unique ID for INVOICE */
  customer_id INT NOT NULL, /* ID of the Customer that rented the videos */
  invoice_date DATETIME NOT NULL, /* Date this invoice was created */
  amount_paid DECIMAL(9,2) NOT NULL, /* Amount the customer initially paid */
  PRIMARY KEY (invoice_id),
  FOREIGN KEY (customer_id) REFERENCES pbkr.CUSTOMER(customer_id)
);

DROP TABLE IF EXISTS pbkr.INVOICE_ITEM;
CREATE TABLE pbkr.INVOICE_ITEM (
  /* 19 INVOICE_ITEM is a table representing line items on an INVOICE */
  invoice_item_id INT NOT NULL, /* Unique ID for INVOICE_ITEM */
  inventory_id INT NOT NULL, /* ID of the INVENTORY_ITEM included on the invoice */
  discount_id INT, /* ID of the DISCOUNT that is applied (if applicable) */
  invoice_id INT NOT NULL, /* ID of the INVOICE this item is included on */
  rental_price DECIMAL(9,2) NOT NULL, /* rental price of the item, after discounts (if any) are applied */
  return_date DATETIME, /* Date the item was returned */
  PRIMARY KEY (invoice_item_id),
  FOREIGN KEY (inventory_id) REFERENCES pbkr.INVENTORY(inventory_id),
  FOREIGN KEY (discount_id) REFERENCES pbkr.DISCOUNT(discount_id),
  FOREIGN KEY (invoice_id) REFERENCES pbkr.INVOICE(invoice_id)
);

DROP TABLE IF EXISTS pbkr.CHARGE;
CREATE TABLE pbkr.CHARGE (
  /* 20 CHARGE is a table containing the extra charges on an INVOICE */
  charge_id INT NOT NULL, /* Unique ID for CHARGE */
  invoice_id INT NOT NULL, /* ID of the INVOICE this charge is included on */
  charge_type_id INT NOT NULL, /* ID of the CHARGE_TYPE of this charge */
  amount DECIMAL(9,2) NOT NULL, /* Amount of the charge */
  PRIMARY KEY (charge_id),
  FOREIGN KEY (invoice_id) REFERENCES pbkr.INVOICE(invoice_id),
  FOREIGN KEY (charge_type_id) REFERENCES pbkr.CHARGE_TYPE(charge_type_id)
);

DROP VIEW IF EXISTS pbkr.INVENTORY_VW;
CREATE VIEW pbkr.INVENTORY_VW AS
  /* utility view that combines data from MOVIE, CATALOG, SHIPMENT_ITEM and INVENTORY */
  SELECT
    inv.inventory_id, inv.rental_price,
  	si.shipment_item_id, si.shipment_id, si.catalog_id,
  	c.movie_id, c.item_type_id,
  	m.title, m.running_length, m.release_date
  FROM pbkr.INVENTORY inv LEFT JOIN
  	(SELECT shipment_item_id, shipment_id, catalog_id from pbkr.SHIPMENT_ITEM) si ON inv.shipment_item_id = si.shipment_item_id LEFT JOIN
  	(SELECT catalog_id, movie_id, item_type_id from pbkr.CATALOG) c ON si.catalog_id = c.catalog_id LEFT JOIN
  	(SELECT movie_id, title, running_length, release_date from pbkr.MOVIE) m ON c.movie_id = m.movie_id;


DROP VIEW IF EXISTS pbkr.DISCOUNT_VW;
CREATE VIEW pbkr.DISCOUNT_VW AS
  /* utility view that combines data from DISCOUNT and MOVIE_GENRE */
  SELECT
  	mg.movie_id, mg.genre_id,
  	d.discount_id, d.start_date, d.end_date, d.discount_percent
  FROM
  	pbkr.MOVIE_GENRE mg LEFT JOIN
  	(SELECT discount_id, genre_id, movie_id, start_date, end_date, discount_percent from pbkr.DISCOUNT) d
  		ON (mg.genre_id = d.genre_id OR mg.movie_id = d.movie_id)
  WHERE d.discount_id > 0;
