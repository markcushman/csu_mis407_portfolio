import csv
import json
import time
import urllib
import argparse
import unicodedata
import configparser

# https://api.themoviedb.org/3/search/movie
# ?api_key=YOUR_KEY_HERE
# &language=en-US
# &query=Django%20Unchained

api_key = None
input_file = None
output_file = None
command = None
language = 'en-US'
url = 'https://api.themoviedb.org/'

parser = argparse.ArgumentParser()
parser.add_argument("command", help="API to call (m_search, m_lookup, p_search, p_lookup)")
parser.add_argument("-c", "--config", help="path to configuration file")
parser.add_argument("-a", "--api_key", help="valid API key for themoviedb.com")
parser.add_argument("-i", "--input_file", help="file for input - one movie name per line")
parser.add_argument("-o", "--output_file", help="path for output - csv format")
args = parser.parse_args()

if args.config:
	config = configparser.ConfigParser()
	config.read(args.config)
	try:
		api_key = config['themoviedb']['api_key']
		try:
			input_file = config['themoviedb']['input_file']
			output_file = config['themoviedb']['output_file']
		except KeyError:
			pass
	except KeyError:
		parser.print_help(file=None)
		parser.exit(status=0,message=None)

if args.api_key:
	api_key = args.api_key
if args.input_file:
	input_file = args.input_file
if args.output_file:
	output_file = args.output_file
if args.command:
	command = args.command

if (None in (api_key,input_file,output_file)) or (command not in ('m_search', 'm_lookup', 'p_search', 'p_lookup')):
	parser.print_help(file=None)
	parser.exit(status=0,message=None)

def gettmdbresults(api, query):
	params = urllib.urlencode({"api_key":api_key, "language":language, "query":query})
	print "%(url)s%(api)s?%(params)s" % {"url":url, "api":api, "params":params}
	themoviedb = urllib.urlopen("%(url)s%(api)s?%(params)s" % {"url":url, "api":api, "params":params})
	return json.loads(themoviedb.read())

with open(input_file, 'rU') as csvfile:
	input_f = csv.reader(csvfile, delimiter=',')

	with open(output_file, 'wb') as output_f:
		writer = csv.writer(output_f)

		#we are searching for movies by name
		if(command == 'm_search'):
			writer.writerow(['query','id','title','release_date','overview'])

			for row in input_f:
				results = gettmdbresults('3/search/movie', row[0])

				for result in results["results"]:
					writer.writerow([row[0],
						result["id"],
						result["title"].encode('utf-8','replace'),
						result["release_date"].encode('utf-8','replace'),
						result["overview"].encode('utf-8','replace')])

				time.sleep(0.25)

		#we are getting movie details by id
		elif(command == 'm_lookup'):
			print "m_lookup"

		#we are searching for people by name
		elif(command == 'p_search'):
			print "p_search"

		#we are getting people details by id
		elif(command == 'p_lookup'):
			print "p_lookup"
			
