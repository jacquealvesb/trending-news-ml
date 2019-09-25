import pandas

df = pandas.read_csv('articles.csv')

def removeColumns(dataframe, columns):
    df = dataframe.drop(columns, axis=1) # remove unecessary columns
    return df

def removeCategories(dataframe, categories):
    df = dataframe
    for category in categories:
        df = df[df.category != category]
    return df

def mergeCategories(dataframe, categories, newCategory):
    df = dataframe
    for index, row in df.iterrows():
        if row['category'] in categories:
            df.set_value(index,'category', newCategory)
    return df

def selectExamples(dataframe, categories, number):
    newDataframe = pandas.DataFrame(columns=['text','category'])
    for category in categories:
        df = dataframe.loc[dataframe['category'] == category]
        df = df.sample(n = min(number,df.shape[0]))
        newDataframe = newDataframe.append(df, ignore_index = True)
    return newDataframe

categoriesToDelete = ['ilustrada', 'ambiente', 'sobretudo', 'colunas', 'educação', 'banco-de-dados', 'opiniao', 'paineldoleitor', 'saopaulo', 'seminariosfolha', 'turismo', 'serafina', 'asmais', 'o-melhor-de-sao-paulo', 'bbc', 'comida', 'folhinha', 'especial', 'treinamento', 'multimidia', 'cenarios-2017', 'topofmind', 'dw', 'ombudsman', 'contas-de-casa', 'mulher', '2016', 'treinamentocienciaesaude', 'rfi', 'euronews', 'vice', 'bichos', 'infograficos', '2015']
columnsText = ['title', 'date', 'subcategory','link']
categoriesNation = ['poder', 'cotidiano']
categoriesBusiness = ['mercado', 'empreendedorsocial']
categoriesEntertainment = ['tv', 'musica', 'guia-de-livros-discos-filmes', 'guia-de-livros-filmes-discos', 'ilustrissima']
categories = ['nation','business', 'world', 'sports', 'technology', 'entertainment', 'science', 'health']

textdf = removeColumns(df, columnsText)
textdf = removeCategories(textdf, categoriesToDelete)
textdf = mergeCategories(textdf,categoriesNation, 'nation')
textdf = mergeCategories(textdf,categoriesBusiness, 'business')
textdf = mergeCategories(textdf,categoriesEntertainment, 'entertainment')
textdf = mergeCategories(textdf,['mundo'], 'world')
textdf = mergeCategories(textdf,['esporte'], 'sports')
textdf = mergeCategories(textdf,['tec'], 'technology')
textdf = mergeCategories(textdf,['equillibrioesaude'], 'health')
textdf = mergeCategories(textdf,['ciencia'], 'science')
textdf = selectExamples(textdf, categories, 1500)

textdf.to_csv('pre-processed-text-dataset.csv', sep='\t')
