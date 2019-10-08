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

df = pandas.read_csv('pre-processed-text-dataset.csv', sep='\t')
df.head()

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
    print(len(category_sentences))
    print(len(category_y))
    # split train and test data
    category_sentences_train, category_sentences_test, category_y_train, category_y_test = train_test_split(category_sentences, category_y, test_size=0.2, shuffle=True) # splitting test and train data

    sentences_train += list(category_sentences_train)
    sentences_test += list(category_sentences_test)
    y_train += list(category_y_train)
    y_test += list(category_y_test)

sentences_train, y_train = shuffle(sentences_train, y_train, random_state = 0)
sentences_test, y_test = shuffle(sentences_test, y_test, random_state = 0)

vectorizer = CountVectorizer()
vectorizer.fit(sentences_train) # creates the vocabulary of train data
print(len(vectorizer.vocabulary_))

x_train = vectorizer.transform(sentences_train) # creates feature vector of training data
print("////")
print(x_train[100].shape)

x_test = vectorizer.transform(sentences_test) # creates feature vector of test data


# saves words_array json to use later in CoreML
vocab = vectorizer.vocabulary_
def convert(o):
    if isinstance(o, np.int64):
        return int(o)
        raise TypeError

for keys in vocab:
    vocab[keys] = int(vocab[keys])

with open('words_array.json', 'w') as fp:
    json.dump(vocab,fp)

classifier = LogisticRegression()
classifier.multi_class = "ovr"
classifier.fit(x_train, y_train) # fits the model according to train data
score = classifier.score(x_test, y_test) # gets the mean accuracy of the test data and labels

print(score)
input_feature = 'newsText'
output_feature = 'category'
coreml_model = coremltools.converters.sklearn.convert(classifier, input_feature, output_feature)

coreml_model.author = 'Jacque Alves e Manuella Valença'
coreml_model.license = 'MIT License'
coreml_model.short_description = 'Brazilian news category prediction.'
coreml_model.input_description['newsText'] = 'An article text as a tokenized array.'
coreml_model.output_description['category'] = 'Most scored category'

coreml_model.save('BrNewsCategoryV3.mlmodel')