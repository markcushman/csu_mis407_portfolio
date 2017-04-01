import csv
import json
import time
import urllib
import argparse
import unicodedata
import configparser

# Script that gets the top 60 movies by rating
# Also gets the current most popular 60 movies

api_key = None
input_file = None
output_file = None
command = None
language = 'en-US'
url = 'https://api.themoviedb.org/'

parser = argparse.ArgumentParser()
parser.add_argument("-c", "--config", help="path to configuration file")
parser.add_argument("-a", "--api_key", help="valid API key for themoviedb.com")
parser.add_argument("-o", "--output_file", help="path for output - csv format")
args = parser.parse_args()

if args.config:
	config = configparser.ConfigParser()
	config.read(args.config)
	try:
		api_key = config['themoviedb']['api_key']
		try:
			output_file = config['themoviedb']['output_file']
		except KeyError:
			pass
	except KeyError:
		parser.print_help(file=None)
		parser.exit(status=0,message=None)

if args.api_key:
	api_key = args.api_key
if args.output_file:
	output_file = args.output_file

if (None in (api_key,output_file)):
	parser.print_help(file=None)
	parser.exit(status=0,message=None)

def gettmdbresults(api, page):
	params = urllib.urlencode({"api_key":api_key, "language":language, "page":page})
	print "%(url)s%(api)s?%(params)s" % {"url":url, "api":api, "params":params}
	themoviedb = urllib.urlopen("%(url)s%(api)s?%(params)s" % {"url":url, "api":api, "params":params})
	return json.loads(themoviedb.read())


with open(output_file, 'wb') as output_f:
	writer = csv.writer(output_f)
	writer.writerow(['id','title','release_date','overview'])

	for page in range(1,4):
		results = gettmdbresults('3/movie/popular', page)
		for result in results["results"]:
			output_row = [result.get("id")]
			output_row.append(result.get("title").encode('utf-8','replace'))
			output_row.append(result.get("release_date").encode('utf-8','replace'))
			output_row.append(result.get("overview").encode('utf-8','replace'))
			writer.writerow(output_row)
		time.sleep(0.25)

	for page in range(1,4):
		results = gettmdbresults('3/movie/top_rated', page)
		for result in results["results"]:
			output_row = [result.get("id")]
			output_row.append(result.get("title").encode('utf-8','replace'))
			output_row.append(result.get("release_date").encode('utf-8','replace'))
			output_row.append(result.get("overview").encode('utf-8','replace'))
			writer.writerow(output_row)
		time.sleep(0.25)
