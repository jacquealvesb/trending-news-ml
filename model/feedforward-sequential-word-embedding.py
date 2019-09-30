import pandas
from sklearn.model_selection import train_test_split
from keras.preprocessing.text import Tokenizer
from keras.preprocessing.sequence import pad_sequences
from keras.models import Sequential
from sklearn.preprocessing import LabelEncoder
from keras import layers

df = pandas.read_csv('pre-processed-text-dataset.csv', sep='\t')
df.head()

sentences = df['text'].values.astype('U')
y = df['category'].values
encoder = LabelEncoder()
y = encoder.fit_transform(y) # transform category label from string to number

sentences_train, sentences_test, y_train, y_test = train_test_split(sentences, y, test_size=0.2, shuffle=True) # splitting test and train data

tokenizer = Tokenizer(num_words = 5000)
tokenizer.fit_on_texts(sentences_train)
x_train = tokenizer.texts_to_sequences(sentences_train)
x_test = tokenizer.texts_to_sequences(sentences_test)
vocab_size = len(tokenizer.word_index) + 1 
print(sentences_train[2],x_train[2])

maxlen = 5453 # size of the largest text
# for sentence in x_train:
#     if len(sentence) > maxlen:
#         maxlen = len(sentence)

x_train = pad_sequences(x_train, padding = 'post', maxlen=maxlen)
x_test = pad_sequences(x_test, padding='post', maxlen=maxlen)

embedding_dim = int(maxlen/2)
model = Sequential()
model.add(layers.Embedding(input_dim = vocab_size, output_dim = embedding_dim, input_length = maxlen))
model.add(layers.Flatten())
model.add(layers.Dense(10, activation = 'relu')) # add a hidden layer 
model.add(layers.Dense(1,activation='sigmoid')) # add output layer 
model.compile(loss='binary_crossentropy',optimizer='adam',metrics=['accuracy'])
model.summary()

history = model.fit(x_train, y_train, epochs = 20, verbose = False, validation_data =(x_test, y_test), batch_size = 10) # fit model into 
loss, accuracy = model.evaluate(x_train, y_train, verbose = False)
print("Training Accuracy: {:.4f}".format(accuracy))
loss, accuracy = model.evaluate(x_test, y_test, verbose=False)
print("Testing Accuracy:  {:.4f}".format(accuracy))

##### graph
import matplotlib.pyplot as plt
plt.style.use('ggplot')

def plot_history(history):
    acc = history.history['acc']
    val_acc = history.history['val_acc']
    loss = history.history['loss']
    val_loss = history.history['val_loss']
    x = range(1, len(acc) + 1)

    plt.figure(figsize=(12, 5))
    plt.subplot(1, 2, 1)
    plt.plot(x, acc, 'b', label='Training acc')
    plt.plot(x, val_acc, 'r', label='Validation acc')
    plt.title('Training and validation accuracy')
    plt.legend()
    plt.subplot(1, 2, 2)
    plt.plot(x, loss, 'b', label='Training loss')
    plt.plot(x, val_loss, 'r', label='Validation loss')
    plt.title('Training and validation loss')
    plt.legend()

    plt.savefig('graph.png')

plot_history(history)
