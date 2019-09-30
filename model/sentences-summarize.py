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
df['text'] = df['text'].values.astype('U')

newDataframe = pandas.DataFrame(columns=['text','category'])

for index, row in df.iterrows():
    text = row['text']
    category = row['category']

    sentences = sent_tokenize(text)
    words = word_tokenize(text.lower())

    stopwords_ = set(stopwords.words('portuguese') + list(punctuation))
    words_without_stopwords = [word for word in words if word not in stopwords_]

    frequency = FreqDist(words_without_stopwords)
    important_sentences = defaultdict(int)

    for i, sentence in enumerate(sentences):
        for word in word_tokenize(sentence.lower()):
            if word in frequency:
                important_sentences[i] += frequency[word]

    idx_important_sentences = nlargest(5, important_sentences, important_sentences.get)
    summary = ''
    for i in sorted(idx_important_sentences):
        summary += sentences[i]
    newDataframe = newDataframe.append({'text': summary, 'category': category}, ignore_index=True, sort=False)

newDataframe.to_csv('summarize-texts.csv', sep='\t')



