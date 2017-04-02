import csv
import time
import random
import decimal
import datetime
import argparse
import configparser
import pymysql.cursors

def strTimeProp(start, end, format, prop):
    stime = time.mktime(time.strptime(start, format))
    etime = time.mktime(time.strptime(end, format))
    ptime = stime + prop * (etime - stime)
    return time.strftime(format, time.localtime(ptime))

def randomDate(start, end, prop):
    #2017-03-01 23:23:59
    return strTimeProp(start, end, '%Y-%m-%d %H:%M:%S', prop)

def getmoviediscount(discount_array, movie_id, date, rental_price):
    returnvalue = ["NULL"]
    returnvalue.append(rental_price)
    ntime = datetime.datetime.strptime(date, '%Y-%m-%d %H:%M:%S')

    #movie_id, start_date, end_date, discount_id, discount_percent
    for row in discount_array:
        if row["movie_id"] == movie_id:
            # print row["start_date"].type()
            # stime = time.mktime(time.strptime(row["start_date"], format))
            # etime = time.mktime(time.strptime(row["end_date"], format))
            if(row["start_date"] < ntime < row["end_date"]):
                returnvalue[0] = row["discount_id"]
                new_price = decimal.Decimal(rental_price) * ((100 - decimal.Decimal(row["discount_percent"])) / 100)
                cents = decimal.Decimal('.01')
                returnvalue[1] = new_price.quantize(cents, decimal.ROUND_HALF_UP)
    return returnvalue

parser = argparse.ArgumentParser()
parser.add_argument("-c", "--config", help="path to valid configuration file")
parser.add_argument("-o", "--output_path", help="path for output - csv files will be genereated here")
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

if args.output_path:
	output_path = args.output_path
else:
    parser.print_help(file=None)
    parser.exit(status=0,message=None)

# Connect to the database
connection = pymysql.connect(host, user, pw, db, charset='utf8mb4', cursorclass=pymysql.cursors.DictCursor)

try:
    with connection.cursor() as cursor:
        #initiate our primary objects and keys
        discount = []
        invoice = []
        invoice_id = 1
        invoice_item = []
        invoice_item_id = 1
        charge = []
        charge_id = 1

        #read in our DISCOUNT table
        sql = "SELECT movie_id, start_date, end_date, discount_id, discount_percent "
        sql += "FROM pbkr.DISCOUNT_VW ORDER BY movie_id ASC, discount_percent DESC"
        cursor.execute(sql)
        for row in cursor:
            discount.append(row)

        # create a number of invoices
        # 12 rentals a day, 30 days in a month, 9 months (approximate!!)
        for i in range(12 * 30 * 9):
            print "Creating invoice %(invoice_id)s out of %(max_invoices)s" % {"invoice_id":invoice_id,"max_invoices":(12 * 30 * 9)}
            cursor.execute("SELECT * from pbkr.CUSTOMER ORDER by RAND() LIMIT 1")
            customer_id = cursor.fetchone()["customer_id"]
            invoice_date = randomDate("2016-06-01 00:00:01", "2017-04-01 23:23:59", random.random())
            amount_paid = 0

            #each customer rents between 1 and 10 movies at a time
            #this will populate our INVOICE_ITEM table
            sql = "SELECT inventory_id, movie_id, item_type_id, rental_price from pbkr.INVENTORY_VW "
            sql += "ORDER by RAND() LIMIT %(rand)s" % {"rand":random.randrange(10)+1}
            cursor.execute(sql)

            for row in cursor:
                item_discount = getmoviediscount(discount, row["movie_id"], invoice_date, row["rental_price"])

                #80% of the movies are returned, 20% are still rented
                if(random.randrange(1, 101) < 80):
                    return_date = randomDate(invoice_date, "2017-04-01 23:23:59", random.random())
                else:
                    return_date = '\N'

                #20% of the VHS tapes (item_type_id=1) are not rewound
                if(return_date != 'NULL' and row["item_type_id"] == "1" and (random.randrange(1, 101) < 21)):
                    new_charge = [charge_id, invoice_id, 3, 0.99]
                    charge.append(new_charge)
                    charge_id += 1

                #5% of the items are damaged
                if(return_date != 'NULL' and (random.randrange(1, 101) < 6)):
                    new_charge = [charge_id, invoice_id, 2, 5.99]
                    charge.append(new_charge)
                    charge_id += 1

                #25% of the items are late
                if(return_date != 'NULL' and (random.randrange(1, 101) < 26)):
                    new_charge = [charge_id, invoice_id, 1, 0.99]
                    charge.append(new_charge)
                    charge_id += 1

                new_invoice_item = [invoice_item_id, row["inventory_id"], item_discount[0], invoice_id, item_discount[1], return_date]
                amount_paid += item_discount[1]
                invoice_item.append(new_invoice_item)
                invoice_item_id += 1

            #now calculate the taxes
            #charge_id, invoice_id, charge_type_id, amount
            new_charge = [charge_id, invoice_id, 4,
                decimal.Decimal(amount_paid * decimal.Decimal('.075')).quantize(decimal.Decimal('.01'), decimal.ROUND_HALF_UP)]
            charge.append(new_charge)
            charge_id += 1
            amount_paid = decimal.Decimal(amount_paid * decimal.Decimal('1.075')).quantize(decimal.Decimal('.01'), decimal.ROUND_HALF_UP)

            new_invoice = [invoice_id, customer_id, invoice_date, amount_paid]
            invoice.append(new_invoice)
            invoice_id += 1


        with open(output_path + "18_invoice.csv", 'wb') as output_i:
            i_writer = csv.writer(output_i)
            #output CSV header
            i_writer.writerow(['invoice_id', 'customer_id', 'invoice_date', 'amount_paid'])
            for z in invoice:
                i_writer.writerow(z)

        with open(output_path + "19_invoice_item.csv", 'wb') as output_ii:
            ii_writer = csv.writer(output_ii)
            #output CSV header
            ii_writer.writerow(['invoice_item_id', 'inventory_id', 'discount_id', 'invoice_id', 'rental_price', 'return_date'])
            for y in invoice_item:
                ii_writer.writerow(y)

        with open(output_path + "20_charge.csv", 'wb') as output_c:
            c_writer = csv.writer(output_c)
            #output CSV header
            c_writer.writerow(['charge_id', 'invoice_id', 'charge_type_id', 'amount'])
            for a in charge:
                c_writer.writerow(a)

finally:
    connection.close()
