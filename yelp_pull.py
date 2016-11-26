import requests
import pprint
import json
import numpy as np
import pandas as pd
import sys
import urllib3
urllib3.disable_warnings()

app_id = 'client_id'
app_secret = 'client_secret'
data = {'grant_type': 'client_credentials',
        'client_id': '2PSDGV0Wx2KBENhQbiuj9Q',
        'client_secret': 'b9cpj54tnjtlgg0DxkwjrJ3YcgQapa06yTmoM0LFT3JFJIZayTGWkzMekJhBvkoF'}
token = requests.post('https://api.yelp.com/oauth2/token', data=data)
access_token = token.json()['access_token']
url = 'https://api.yelp.com/v3/businesses/search'
headers = {'Authorization': 'bearer %s' % access_token}

#Initialize Arrays for Storage
names = []
ratings = []
city = []
state = []
address = []
zip_code = []

for zips in range(94000,96000):
    params = {'location': zips,
              'terms': 'hospital',
              'categories': 'medcenters',
              'limit': 50
              }

    resp = requests.get(url=url, params=params, headers=headers)
    data = resp.json()


    if resp.status_code == 200: #Status Code 200 means a succesful returned response from Yelp
        for i in data['businesses']:
            names.append(i['name'])
            ratings.append(i['rating'])
            city.append(i['location']['city'])
            address.append(i['location']['address1'])
            state.append(i['location']['state'])
            zip_code.append(i['location']['zip_code'])


#Coerce Data into Data Frame
d = {'Name': names,'Rating':ratings,'City':city,'State':state,
     'Address': address,"ZipCode": zip_code}
df = pd.DataFrame(d)
print(df)
df.drop_duplicates()
df.to_csv('yelp_hospitals.csv',encoding = 'utf-8')
