import pandas

df = pandas.read_csv('articles.csv')

def removeColumns(dataframe, columns): # remove unecessary columns from dataframe
    df = dataframe.drop(columns, axis=1) 
    return df

def removeCategories(dataframe, categories): # remove unwanted categories from dataframe
    df = dataframe
    for category in categories:
        df = df[df.category != category]
    return df

def mergeCategories(dataframe, categories, newCategory): # change categories names to newCategory
    df = dataframe
    for index, row in df.iterrows():
        if row['category'] in categories:
            df.at[index,'category'] = newCategory
    return df

def selectExamples(dataframe, dataColumn, categories, number): # returns a new data frame containing number samples from each category
    newDataframe = pandas.DataFrame(columns=[dataColumn,'category'])
    for category in categories:
        df = dataframe.loc[dataframe['category'] == category] # selects all rows of a category
        df = df.sample(n = min(number,df.shape[0])) # gets n samples of that category

        newDataframe = newDataframe.append(df, ignore_index = True, sort=False) # appends the selected samples to new data frame
        
    return newDataframe

categoriesToDelete = ['ilustrada', 'ambiente', 'sobretudo', 'colunas', 'educação', 'banco-de-dados', 'opiniao', 'paineldoleitor', 'saopaulo', 'seminariosfolha', 'turismo', 'serafina', 'asmais', 'o-melhor-de-sao-paulo', 'bbc', 'comida', 'folhinha', 'especial', 'treinamento', 'multimidia', 'cenarios-2017', 'topofmind', 'dw', 'ombudsman', 'contas-de-casa', 'mulher', '2016', 'treinamentocienciaesaude', 'rfi', 'euronews', 'vice', 'bichos', 'infograficos', '2015']
columnsText = ['title', 'date', 'subcategory','link']
columnsTitle = ['text', 'date', 'subcategory','link']
categories = {
    'nation' : ['poder', 'cotidiano'],
    'business': ['mercado', 'empreendedorsocial'], 
    'world': ['mundo'], 
    'sports': ['esporte'], 
    'technology': ['tec'], 
    'entertainment': ['tv', 'musica', 'guia-de-livros-discos-filmes', 'guia-de-livros-filmes-discos', 'ilustrissima'], 
    'science': ['ciencia'], 
    'health': ['equilibrioesaude']
}

##### Dataset with text-category

# delete rows with text smaller than 1000 words or is number
for index, row in df.iterrows():
    if type(row['text']) == str:
        sentence_len = len(row['text'])
        if sentence_len < 1000:
            df = df.drop(index, axis=0)
    if type(row['text']) != str:
        df = df.drop(index, axis=0)

textdf = removeColumns(df, columnsText)
textdf = removeCategories(textdf, categoriesToDelete)

for new, olds in categories.items(): # rename all old categories to the new name
    textdf = mergeCategories(textdf, olds, new)

textdf = selectExamples(textdf, 'text', list(categories.keys()), 1500)
textdf = textdf[['text', 'category']]

textdf.to_csv('pre-processed-text-dataset-length-limit.csv', sep='\t')

##### Dataset with title-category
# titledf = removeColumns(df, columnsTitle)
# titledf = removeCategories(titledf, categoriesToDelete)

# for new, olds in categories.items(): # rename all old categories to the new name
#     titledf = mergeCategories(titledf, olds, new)

# titledf = selectExamples(titledf, 'title', list(categories.keys()), 1500)
# titledf = titledf[['title', 'category']]

# titledf.to_csv('pre-processed-title-dataset-length-limit.csv', sep='\t')

