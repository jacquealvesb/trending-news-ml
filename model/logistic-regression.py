import pandas
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.linear_model import LogisticRegression
import coremltools
import json
import ujson
import numpy as np

df = pandas.read_csv('pre-processed-text-dataset.csv', sep='\t')
df.head()

sentences = df['text'].values.astype('U')
y = df['category'].values

sentences_train, sentences_test, y_train, y_test = train_test_split(sentences, y, test_size=0.2, shuffle=True) # splitting test and train data

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