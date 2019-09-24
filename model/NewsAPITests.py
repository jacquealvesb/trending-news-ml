import requests
import pandas
import json

url = ('https://newsapi.org/v2/top-headlines?''country=br&''apiKey=f68f6e296da64d9397688593270fe001')
response = requests.get(url)

df = pandas.read_json(json.dumps(response.json()['articles']), orient='records')
columns = ['author','source','description','urlToImage']
df = df.drop(columns, axis=1)
categories = ['esporte'] * df.shape[0]
df.insert(4, 'category', categories, True) 
df.to_csv('/Users/manuellavalenca/Downloads/tabelinha.csv',index=False, sep='\t', enconding = 'utf-8')
print df