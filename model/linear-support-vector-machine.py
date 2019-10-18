import pandas
from sklearn.model_selection import train_test_split
from keras.preprocessing.text import Tokenizer
from keras.preprocessing.sequence import pad_sequences
from sklearn import svm
from keras.models import Sequential
from sklearn.preprocessing import StandardScaler
from sklearn.preprocessing import LabelEncoder
from sklearn.metrics import accuracy_score
from keras import layers
from sklearn.utils import shuffle
from math import ceil
import numpy as np
from nltk.corpus import stopwords
import re 
from sklearn.decomposition import PCA
import pylab as pl
from sklearn.linear_model import SGDClassifier
from sklearn.pipeline import Pipeline
from sklearn.feature_extraction.text import TfidfTransformer
from sklearn.feature_extraction.text import CountVectorizer, TfidfVectorizer
from sklearn.multiclass import OneVsRestClassifier
from sklearn.svm import LinearSVC


df = pandas.read_csv('summarize-texts.csv', sep='\t')
df.head()

encoder = LabelEncoder()
df['category'] = encoder.fit_transform(df['category'].values) # transform category label from string to number

sentences_train = []
sentences_test = []
y_train = []
y_test = []

for category in set(df['category'].values):
    category_table = df.loc[df['category'] == category]
    category_sentences_values = category_table['text'].values.astype('U')
    category_y = category_table['category'].values
    category_sentences = []

    # remove stopwords, punctuation, from sentences
    stopwords_ = set(stopwords.words('portuguese'))
    for sentence in category_sentences_values:
        for stopword in stopwords_:
            if stopword == '\\':
                stopword = '\\\\'
            rule = r'\b'+ re.escape(stopword) + r'\b'
            sentence = sentence.lower()
            sentence = re.sub(r'[^\w\s]','', sentence) # remove  sentences
            sentence = re.sub(rule,'', sentence) # remove  from sentences
            sentence = re.sub(r'[0-9]', '', sentence) # remove numbers from sentences
            sentence = re.sub(r'\s+', ' ', sentence) # remove extra spaces from sentences
            sentence = re.sub(r'(?:^| )\w(?:$| )', ' ', sentence).strip() # remove single character words sentences
        category_sentences.append(sentence)

    # split train and test data
    category_sentences_train, category_sentences_test, category_y_train, category_y_test = train_test_split(category_sentences, category_y, test_size=0.2, shuffle=True) # splitting test and train data

    sentences_train += list(category_sentences_train)
    sentences_test += list(category_sentences_test)
    y_train += list(category_y_train)
    y_test += list(category_y_test)

sentences_train, y_train = shuffle(sentences_train, y_train, random_state = 0)
sentences_test, y_test = shuffle(sentences_test, y_test, random_state = 0)

sgd = Pipeline([('vect', CountVectorizer()),
                ('tfidf', TfidfTransformer()),
                ('clf', OneVsRestClassifier(LinearSVC()))
               ])
sgd.fit(sentences_train, y_train)
y_pred = sgd.predict(sentences_test)

print('accuracy %s' % accuracy_score(y_pred, y_test))