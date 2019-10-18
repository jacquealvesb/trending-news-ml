import pandas
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.linear_model import LogisticRegression
from nltk.corpus import stopwords
import re 
from sklearn.utils import shuffle
import coremltools
import json
import ujson
import numpy as np
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.feature_extraction.text import TfidfTransformer
from sklearn.feature_selection import chi2
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.metrics import classification_report
from sklearn.pipeline import Pipeline
from keras.models import Sequential
from sklearn.preprocessing import LabelEncoder
from sklearn.metrics import accuracy_score

df = pandas.read_csv('pre-processed-text-dataset-length-limit.csv', sep='\t')
df.head()
# df = df[df.category != 'entertainment']

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
    category_sentences_train, category_sentences_test, category_y_train, category_y_test = train_test_split(category_sentences, category_y, test_size=0.2, shuffle=True) 
    sentences_train += list(category_sentences_train)
    sentences_test += list(category_sentences_test)
    y_train += list(category_y_train)
    y_test += list(category_y_test)

sentences_train, y_train = shuffle(sentences_train, y_train, random_state = 0)
sentences_test, y_test = shuffle(sentences_test, y_test, random_state = 0)

lrm = Pipeline([('vect', CountVectorizer()),
               ('tfidf', TfidfTransformer()),
               ('clf', LogisticRegression()),
              ])
lrm.fit(sentences_train, y_train)
y_pred = lrm.predict(sentences_test)

print('accuracy %s' % accuracy_score(y_pred, y_test))

# Export to MLModel
# input_feature = 'newsText'
# output_feature = 'category'
# coreml_model = coremltools.converters.sklearn.convert(classifier, input_feature, output_feature)

# coreml_model.author = 'Jacque Alves e Manuella Valença'
# coreml_model.license = 'MIT License'
# coreml_model.short_description = 'Brazilian news category prediction.'
# coreml_model.input_description['newsText'] = 'An article text as a tokenized array.'
# coreml_model.output_description['category'] = 'Most scored category'

# coreml_model.save('BrNewsCategoryV3.mlmodel')