import csv
import random
import decimal
import argparse
import configparser
import pymysql.cursors

parser = argparse.ArgumentParser()
parser.add_argument("-c", "--config", help="path to valid configuration file")
parser.add_argument("-o", "--output_file", help="path for output - csv format")
args = parser.parse_args()

if args.config:
    config = configparser.ConfigParser()
    config.read(args.config)
    try:
        host = config['pymysql']['host']
        user = config['pymysql']['user']
        pw = config['pymysql']['pw']
        db = config['pymysql']['db']
    except KeyError:
        parser.print_help(file=None)
        parser.exit(status=0,message=None)

if args.output_file:
	output_file = args.output_file
else:
    parser.print_help(file=None)
    parser.exit(status=0,message=None)

# Connect to the database
connection = pymysql.connect(host, user, pw, db, charset='utf8mb4', cursorclass=pymysql.cursors.DictCursor)

try:
    with connection.cursor() as cursor:
        #initiate our primary key
        inventory_id = 1
        #iterate through our shipments (we currently have 50)
        #TODO make the range iterate through the ACTUAL shipment ids via SQL

    	with open(output_file, 'wb') as output_f:
            writer = csv.writer(output_f)
            #output CSV header
            writer.writerow(['inventory_id','shipment_item_id','rental_price'])

            #get a list of SHIPMENT_ITEMs, iterate through them and for the number of items shipped,
            #enter each one into our inventory
            sql = "SELECT shipment_item_id, quantity, item_cost FROM pbkr.SHIPMENT_ITEM"
            cursor.execute(sql)

            for row in cursor:
                shipment_item_id = row["shipment_item_id"]
                quantity = row["quantity"]
                item_cost = row["item_cost"]
                if(item_cost < 5.00):
                    rental_price = 0.99
                elif(item_cost > 11.00):
                    rental_price = 2.99
                else:
                    rental_price = 1.99

                for x in range(1, quantity + 1):
                    #print "Shipment: %(shipment_item_id)s, Quantity: %(quantity)s, Item Cost %(item_cost)s, Rental Price %(rental_price)s" % {
                    #    "shipment_item_id":shipment_item_id,
                    #    "quantity":quantity,
                    #    "item_cost":item_cost,
                    #    "rental_price":rental_price
                    #}

                    #simulate ~15% breakage by randomly skipping a portion
                    if(random.randrange(1, 101) > 15):
                        writer.writerow([inventory_id, shipment_item_id, rental_price])

                    inventory_id += 1

finally:
    connection.close()
