import pandas
from sklearn.model_selection import train_test_split
from keras.preprocessing.text import Tokenizer
from keras.preprocessing.sequence import pad_sequences
from keras.models import Sequential
from keras.wrappers.scikit_learn import KerasClassifier
from sklearn.model_selection import RandomizedSearchCV
from sklearn.preprocessing import LabelEncoder
from keras import layers
from sklearn.utils import shuffle
from math import ceil
import numpy as np
from nltk.corpus import stopwords
import re 

def create_model(num_filters,kernel_size,vocab_size,embedding_dim, maxlen):  
    model = Sequential()
    model.add(layers.Embedding(input_dim = vocab_size, output_dim = embedding_dim, input_length = maxlen))
    model.add(layers.Conv1D(num_filters,kernel_size, activation='relu'))
    model.add(layers.GlobalMaxPool1D())
    model.add(layers.Dense(10, activation = 'relu')) # add a hidden layer 
    model.add(layers.Dense(1,activation='sigmoid')) # add output layer 
    model.compile(loss='binary_crossentropy',optimizer='adam',metrics=['accuracy'])
    return model
    
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
    print(len(category_sentences))
    print(len(category_y))
df.to_csv('table-dataset-pre-processed-test.csv', sep='\t')

    # split train and test data
#     category_sentences_train, category_sentences_test, category_y_train, category_y_test = train_test_split(category_sentences, category_y, test_size=0.2, shuffle=True) # splitting test and train data

#     sentences_train += list(category_sentences_train)
#     sentences_test += list(category_sentences_test)
#     y_train += list(category_y_train)
#     y_test += list(category_y_test)

# sentences_train, y_train = shuffle(sentences_train, y_train, random_state = 0)
# sentences_test, y_test = shuffle(sentences_test, y_test, random_state = 0)

# tokenizer = Tokenizer(num_words = 5000)
# tokenizer.fit_on_texts(sentences_train)
# x_train = tokenizer.texts_to_sequences(sentences_train)
# x_test = tokenizer.texts_to_sequences(sentences_test)

# vocab_size = len(tokenizer.word_index) + 1 

# maxlen = 0 # size of the largest text
# for sentence in x_train:
#     if len(sentence) > maxlen:
#         maxlen = len(sentence)
# print(maxlen)

# x_train = pad_sequences(x_train, padding = 'post', maxlen=maxlen)
# x_test = pad_sequences(x_test, padding='post', maxlen=maxlen)

# x_train = np.array(x_train)
# y_train = np.array(y_train)

# x_test = np.array(x_test)
# y_test = np.array(y_test)

# embedding_dim = ceil(maxlen/2)
# param_grid = dict(num_filters = [32, 64, 128], kernel_size = [3, 5, 7], vocab_size = [vocab_size], embedding_dim = [embedding_dim], maxlen = [maxlen])
# epochs = 20
# model = KerasClassifier(build_fn = create_model, epochs = epochs, batch_size = 10, verbose = False)
# grid = RandomizedSearchCV(estimator = model, param_distributions = param_grid, cv = 4, verbose = 1, n_iter = 5)
# grid_result = grid.fit(x_train, y_train)

# test_accuracy = grid.score(x_test, y_test)

# # Save and evaluate results
# # prompt = input(f'finished {source}; write to file and proceed? [y/n]')
# # if prompt.lower() not in {'y', 'true', 'yes'}:
# #     break
# with open(output_file, 'a') as f:
#     s = ('Running {} data set\nBest Accuracy : '
#             '{:.4f}\n{}\nTest Accuracy : {:.4f}\n\n')
#     output_string = s.format(
#         grid_result.best_score_,
#         grid_result.best_params_,
#         test_accuracy)
#     print(output_string)
#     f.write(output_string)

# history = model.fit(x_train, y_train,
#                     epochs=20,
#                     verbose=False,
#                     validation_data=(x_test, y_test),
#                     batch_size=10)
# loss, accuracy = model.evaluate(x_train, y_train, verbose = False)
# print("Training Accuracy: {:.4f}".format(accuracy))
# loss, accuracy = model.evaluate(x_test, y_test, verbose=False)
# print("Testing Accuracy:  {:.4f}".format(accuracy))

# ##### graph
# import matplotlib.pyplot as plt
# plt.style.use('ggplot')

# def plot_history(history):
#     acc = history.history['acc']
#     val_acc = history.history['val_acc']
#     loss = history.history['loss']
#     val_loss = history.history['val_loss']
#     x = range(1, len(acc) + 1)

#     plt.figure(figsize=(12, 5))
#     plt.subplot(1, 2, 1)
#     plt.plot(x, acc, 'b', label='Training acc')
#     plt.plot(x, val_acc, 'r', label='Validation acc')
#     plt.title('Training and validation accuracy')
#     plt.legend()
#     plt.subplot(1, 2, 2)
#     plt.plot(x, loss, 'b', label='Training loss')
#     plt.plot(x, val_loss, 'r', label='Validation loss')
#     plt.title('Training and validation loss')
#     plt.legend()

#     plt.savefig('graph.png')

# plot_history(history)
