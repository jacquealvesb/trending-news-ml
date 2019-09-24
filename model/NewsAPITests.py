import requests
import pandas
import json

url = ('https://newsapi.org/v2/top-headlines?''country=br&''apiKey=f68f6e296da64d9397688593270fe001')
response = requests.get(url) # make request to NewsAPI

df = pandas.read_json(json.dumps(response.json()['articles']), orient='records') # gets the articles returned

columns = ['author','source','description','urlToImage'] # unecessary columns to be removed
df = df.drop(columns, axis=1) # remove unecessary columns

categories = ['esporte'] * df.shape[0] # create array of categories to add new column to data frama (test)
df.insert(4, 'category', categories, True)  # insert category column to data frame

df = df[['title', 'content', 'publishedAt', 'category', 'url']] # reorganizing columns 

df.to_csv('news-table.csv', sep='\t') # saving data frama to csv

print(df)