import requests
import config as C 
import json
from datetime import datetime 
import os

def get_weather():
	print(os.environ['AIRFLOW_CTX_EXECUTION_DATE'])

	"""
	Query openweathermap.com's API and to get the weather for
	Brooklyn, NY and then dump the json to the /src/data/ directory 
	with the file name "<today's date>.json"
	"""

	# My API key is defined in my config.py file.
	paramaters = {'q': 'Brooklyn, USA', 'appid':C.API_KEY}

	result     = requests.get("http://api.openweathermap.org/data/2.5/weather?", paramaters)

	# If the API call was sucessful, get the json and dump it to a file with 
	# today's date as the title.
	if result.status_code == 200 :

		# Get the json data 
		json_data = result.json()
		file_name  = str(datetime.now().date()) + '.json'
		tot_name   = os.path.join(os.path.dirname(__file__), 'data', file_name)

		if C.DEBUG:
			print(json.dumps(json_data, indent=4))

		with open(tot_name, 'w') as outputfile:
			json.dump(json_data, outputfile, indent=4)
	else :
		print("Error In API call.")


if __name__ == "__main__":
	get_weather()
