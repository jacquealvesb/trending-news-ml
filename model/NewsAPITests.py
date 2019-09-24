import requests
import pandas
import json

url = ('https://newsapi.org/v2/top-headlines?''country=br&''apiKey=f68f6e296da64d9397688593270fe001')
response = requests.get(url)

df = pandas.read_json(json.dumps(response.json()['articles']), orient='records')
columns = ['author','source','description','urlToImage']
df = df.drop(columns, axis=1)

print df