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
textdf = selectExamples(textdf, 'text', categories, 1500)
textdf = textdf[['text', 'category']]

textdf.to_csv('pre-processed-text-dataset.csv', sep='\t')

titledf = removeColumns(df, columnsTitle)
titledf = removeCategories(titledf, categoriesToDelete)
titledf = mergeCategories(titledf,categoriesNation, 'nation')
titledf = mergeCategories(titledf,categoriesBusiness, 'business')
titledf = mergeCategories(titledf,categoriesEntertainment, 'entertainment')
titledf = mergeCategories(titledf,['mundo'], 'world')
titledf = mergeCategories(titledf,['esporte'], 'sports')
titledf = mergeCategories(titledf,['tec'], 'technology')
titledf = mergeCategories(titledf,['equillibrioesaude'], 'health')
titledf = mergeCategories(titledf,['ciencia'], 'science')
titledf = selectExamples(titledf, 'title', categories, 1500)
titledf = titledf[['title', 'category']]

titledf.to_csv('pre-processed-title-dataset.csv', sep='\t')

