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
        shipment_item_id = 1
        #iterate through our shipments (we currently have 50)
        #TODO make the range iterate through the ACTUAL shipment ids via SQL

    	with open(output_file, 'wb') as output_f:
            writer = csv.writer(output_f)
            #output CSV header
            writer.writerow(['shipment_item_id','catalog_id','shipment_id','quantity','item_cost'])

            for shipment_id in range(1,51):
                #return a list of catalog_ids from CATALOG where the distributor is the same as in our SHIPMENT
                #this will essentially get us the distributor catalog
                sql = "SELECT catalog_id, wholesale_cost FROM pbkr.CATALOG WHERE distributor_id = (SELECT distributor_id "
                sql += "FROM pbkr.SHIPMENT WHERE shipment_id = %(shipment_id)s) ORDER BY RAND()" % {"shipment_id":shipment_id}
                #print sql
                cursor.execute(sql)

                #now pick a random amount of catalog items (1..30) from the catalog to include in this shipment
                #TODO this block of code is kind of messy, I'm sure it could be improved

                j = 1
                k = random.randrange(30)

                for row in cursor:
                    quantity = random.randrange(20)+1

                    #if we are buying more than 10 items, we get a 25% discount
                    if quantity > 9:
                        discount_cost = decimal.Decimal(row["wholesale_cost"]) * decimal.Decimal('.75')
                        cents = decimal.Decimal('.01')
                        item_cost = discount_cost.quantize(cents, decimal.ROUND_HALF_UP)
                    else:
                        item_cost = row["wholesale_cost"]

                    writer.writerow([shipment_item_id, row["catalog_id"], shipment_id, quantity, item_cost])
                    shipment_item_id += 1
                    if j == k:
                        break
                    else:
                        j += 1

finally:
    connection.close()
