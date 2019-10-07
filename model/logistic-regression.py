import pandas
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.linear_model import LogisticRegression
import coremltools

df = pandas.read_csv('pre-processed-text-dataset.csv', sep='\t')
df.head()

sentences = df['text'].values.astype('U')
y = df['category'].values

sentences_train, sentences_test, y_train, y_test = train_test_split(sentences, y, test_size=0.2, shuffle=True) # splitting test and train data

vectorizer = CountVectorizer()
vectorizer.fit(sentences_train) # creates the vocabulary of train data

x_train = vectorizer.transform(sentences_train) # creates feature vector of training data
x_test = vectorizer.transform(sentences_test) # creates feature vector of test data

classifier = LogisticRegression()
classifier.multi_class = "ovr"
classifier.fit(x_train, y_train) # fit the model according to train data
score = classifier.score(x_test, y_test) # gets the mean accuracy of the test data and labels

print(score)
print(type(classifier))
input_feature = 'newsText'
output_feature = 'category'
coreml_model = coremltools.converters.sklearn.convert(classifier, input_feature, output_feature)

coreml_model.author = 'Jacque Alves e Manuella Valença'
coreml_model.license = 'MIT License'
coreml_model.short_description = 'Brazilian news category prediction.'
coreml_model.input_description['newsText'] = 'An article text as a tokenized array.'
coreml_model.output_description['category'] = 'Most scored category'

coreml_model.save('BrNewsCategoryV2.mlmodel')


