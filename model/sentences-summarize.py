import pandas
from nltk.tokenize import word_tokenize
from nltk.tokenize import sent_tokenize
from nltk.corpus import stopwords
from nltk.probability import FreqDist
from string import punctuation
from collections import defaultdict
from heapq import nlargest


df = pandas.read_csv('pre-processed-text-dataset.csv', sep='\t', )
df.head()
df['text'] = df['text'].values.astype('U') # converting the text column to be used

newDataframe = pandas.DataFrame(columns=['text','category']) # data frame with summarized sentences

for index, row in df.iterrows():
    text = row['text']
    category = row['category']

    sentences = sent_tokenize(text) # separates each sentence on the text
    words = word_tokenize(text.lower()) # gets all words from the text

    stopwords_ = set(stopwords.words('portuguese') + list(punctuation)) # gets the portuguese stopwords
    words_without_stopwords = [word for word in words if word not in stopwords_] # filters the words to only get the ones that are not stopwords

    frequency = FreqDist(words_without_stopwords) # how many times each words appears on the text
    important_sentences = defaultdict(int) # create an empty dictionary of type int

    for i, sentence in enumerate(sentences):
        for word in word_tokenize(sentence.lower()): # iterates over all words on each sentence
            if word in frequency: # checks if the word is one of the most frequent 
                important_sentences[i] += frequency[word] # adds this sentence to the most important ones

    idx_important_sentences = nlargest(5, important_sentences, important_sentences.get) # gets the indexes of the five most important senteces
    summary = ''
    for i in sorted(idx_important_sentences):
        summary += sentences[i] # creates a text with the most important sentences of the text
    newDataframe = newDataframe.append({'text': summary, 'category': category}, ignore_index=True, sort=False) # appends to the new data frame

newDataframe.to_csv('summarize-texts.csv', sep='\t')



