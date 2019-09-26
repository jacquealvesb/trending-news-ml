import pandas
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.linear_model import LogisticRegression

df = pandas.read_csv('pre-processed-title-dataset.csv', sep='\t')
df.head()

sentences = df['title'].values
y = df['category'].values

sentences_train, sentences_test, y_train, y_test = train_test_split(sentences, y, test_size=0.2, shuffle=True) # splitting test and train data

vectorizer = CountVectorizer()
vectorizer.fit(sentences_train) # creates the vocabulary of train data

x_train = vectorizer.transform(sentences_train) # creates feature vector of training data
x_test = vectorizer.transform(sentences_test) # creates feature vector of test data

classifier = LogisticRegression()
classifier.fit(x_train, y_train) # fit the model according to train data
score = classifier.score(x_test, y_test) # gets the mean accuracy of the test data and labels

print(score)



