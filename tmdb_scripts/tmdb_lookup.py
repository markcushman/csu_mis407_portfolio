import csv
import json
import time
import urllib
import argparse
import unicodedata
import configparser

# Script that searches for movies or people by name and returns a movie or person id
# Optionally gets the details for a movie or person by id

api_key = None
input_file = None
output_file = None
command = None
language = 'en-US'
url = 'https://api.themoviedb.org/'

parser = argparse.ArgumentParser()
parser.add_argument("command", help="API to call (m_search, p_search, gen_movie, gen_cast, gen_movie_genre, gen_person)")
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

if (None in (api_key,input_file,output_file)) or (command not in (
		'm_search', 'p_search', 'gen_movie', 'gen_cast', 'gen_movie_genre', 'gen_person')):
	parser.print_help(file=None)
	parser.exit(status=0,message=None)

def gettmdbresults(api, parameters):
	full_parameters = {"api_key":api_key, "language":language}
	if(parameters != None):
		full_parameters.update(parameters)
	params = urllib.urlencode(full_parameters)
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
				results = gettmdbresults('3/search/movie', 'query=' + row[0])
				for result in results["results"]:
					output_row = [row[0]]
					output_row.append(result.get("id"))
					output_row.append(result.get("title").encode('utf-8','replace'))
					output_row.append(result.get("release_date").encode('utf-8','replace'))
					output_row.append(result.get("overview").encode('utf-8','replace'))
					writer.writerow(output_row)
				time.sleep(0.25)

		#generate a movie table
		elif(command == 'gen_movie'):
			writer.writerow(['movie_id','title','running_length','release_date','description'])

			for row in input_f:
				result = gettmdbresults('3/movie/' + row[0], None)

				output_row = [result.get("id")]
				output_row.append(result.get("title").encode('utf-8','replace'))
				output_row.append(result.get("runtime"))
				output_row.append(result.get("release_date").encode('utf-8','replace'))
				output_row.append(result.get("overview").replace('\n', ' ').replace('\r', ' ').encode('utf-8','replace'))

				writer.writerow(output_row)
				time.sleep(0.25)

		#generate the cast table
		elif(command == 'gen_cast'):
			writer.writerow(['movie_id', 'role_id', 'person_id'])

			for row in input_f:
				result = gettmdbresults('3/movie/' + row[0], {'append_to_response':'credits'})

				for cast in result.get("credits").get("cast")[:8]:
					output_row = [result.get("id")]
					# 2 - id for the Actor role_id
					output_row.append('2')
					output_row.append(cast.get("id"))
					writer.writerow(output_row)

				for crew in result.get("credits").get("crew"):
					if(crew.get("job") == "Director"):
						output_row = [result.get("id")]
						# 1 - id for the Director role_id
						output_row.append('1')
						output_row.append(crew.get("id"))
						writer.writerow(output_row)

				time.sleep(0.25)

		#generate the genre table
		elif(command == 'gen_movie_genre'):
			writer.writerow(['genre_name','movie_id'])

			for row in input_f:
				result = gettmdbresults('3/movie/' + row[0], {'append_to_response':'credits'})

				for genre in result.get("genres")[:4]:
					output_row = [genre.get("name").encode('utf-8','replace')]
					output_row.append(result.get("id"))
					writer.writerow(output_row)

				time.sleep(0.25)

		#we are searching for people by name
		elif(command == 'p_search'):
			writer.writerow(['query','id','name','known_fors'])

			for row in input_f:
				results = gettmdbresults('3/search/person', 'query=' + row[0])
				for result in results["results"]:
					output_row = [row[0]]
					output_row.append(result.get("id"))
					output_row.append(result.get("name").encode('utf-8','replace'))
					for known_for in result["known_for"]:
						if("title" in known_for):
							output_row.append(known_for.get("title").encode('utf-8','replace'))
						elif("name" in known_for):
							output_row.append(known_for.get("name").encode('utf-8','replace'))
					writer.writerow(output_row)
				time.sleep(0.25)

		#generate the person table
		elif(command == 'gen_person'):
			writer.writerow(['person_id','name','birthday','description'])

			for row in input_f:
				result = gettmdbresults('3/person/' + row[0], None)

				output_row = [result.get("id")]
				output_row.append(result.get("name").encode('utf-8','replace'))
				if (result.get("birthday") != None):
					output_row.append(result.get("birthday").encode('utf-8','replace'))
				else:
					output_row.append('')					
				if (result.get("biography") != None):
					output_row.append(result.get("biography").replace('\n', '<br>').replace('\r', '<br>').encode('utf-8','replace'))
				else:
					output_row.append('')
				writer.writerow(output_row)
				time.sleep(0.25)
