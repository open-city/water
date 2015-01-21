import requests
import csv
import os

script_dir = os.path.dirname(__file__)
base_url = 'https://api.forecast.io/forecast/cca824ca4656719ca90c104fabf03aa0/'
airport_name = 'OHARE'
coords = (41.995, -87.9336)
q = requests.get('https://api.forecast.io/forecast/cca824ca4656719ca90c104fabf03aa0/,2007-01-01T00:00:00')
hourly_data = q.json()['hourly']['data']

csv_filename = script_dir + '../../data/forecast/' + airport_name + '.csv'

def get_last_row(csv_filename):
    with open(csv_filename, 'rb') as f:
        return deque(csv.reader(f), 1)[0]

last_row = 

with open(csv_filename, 'wb') as csvfile:
    for hourly_datum in hourly_data:

        
    spamwriter = csv.writer(csvfile, delimiter=' ',
                            quotechar='|', quoting=csv.QUOTE_MINIMAL)
    spamwriter.writerow(['Spam'] * 5 + ['Baked Beans'])
    spamwriter.writerow(['Spam', 'Lovely Spam', 'Wonderful Spam'])


    
#['data'][0]['precipIntensity']


