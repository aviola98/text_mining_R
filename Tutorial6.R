#tutorial 6
#tm package

library(readr)
library(stringr)

dados_noticias <- read_delim("https://raw.githubusercontent.com/thiagomeireles/cebraplab_captura_2021/main/dados/dados_noticias2.csv", 
                             delim = ";", locale = locale(encoding = "WINDOWS-1252"))

noticias <- dados_noticias$texto

library(tm)

#a good practice to work with texts is to transform all the words into lower case

noticias2 <- tolower(noticias)

#ponctuation can also be a problem when working with text 

noticias2 <- removePunctuation(noticias2)

#numbers can also be a problem

noticias2 <- removeNumbers(noticias2)

#let's take a new look to the word cloud

library(wordcloud)
wordcloud(noticias2, max.words= 50)

#removing stopwords
#setting stopwords into portuguese

stopwords("pt")

noticias2 <- removeWords(noticias2, stopwords("pt"))

#removing excessive white space

noticias2 <- stripWhitespace(noticias2)

#new wordcloud

wordcloud(noticias2, max.words=50)

#incrementing the stopword list 
stopwords_pt <- c(stopwords("pt"), "sobre","após","folha","nesta")

#creating a new object removing the added stopwords
noticias3 <- removeWords(noticias2, stopwords_pt)

#creating a new wordcloud
wordcloud(noticias3, max.words=50)

#wordstem
#e.g. in english
#stemDocument(c("politics", "political", "politically"), language = "english")

noticias4 <- stemDocument(noticias3, language="portuguese")

#tokenization

tokens <- str_split(noticias3, " ")
tokens

#using unlist in order to transform the list into an unique vector

tokens_noticias <- unlist(tokens)

#creating a corpus with a vector source
noticias_source <- VectorSource(noticias)
noticias_corpus <- VCorpus(noticias_source)

#observing what's located in the first position of a VCorpus
#notice that a corpus is a list
str(noticias_corpus[[1]])

#let's reopen the data using a dataframe as a source

noticias_df <- data.frame(doc_id = as.character(1:length(noticias)),
                          text = noticias,
                          stringsAsFactors = F)
str(noticias_df)
#repeating the process but using Dataframe source in order to indicate the source of the data
noticias_df_source <- DataframeSource(noticias_df)
noticias_df_corpus <- VCorpus(noticias_df_source)

#when working with a corpus we do not directly apply the functions of the tm package
#we use tm_map instead

noticias_corpus <- tm_map(noticias_corpus, removePunctuation)

#when the function does not belong to the tm package we use the function content_tranformer
noticias_corpus <- tm_map(noticias_corpus, content_transformer(tolower))

#removing words and numbers
noticias_corpus <- tm_map(noticias_corpus, removeNumbers)
noticias_corpus <- tm_map(noticias_corpus, removeWords, stopwords("pt"))

#we can also put all this code into a function

limpa_corpus <- function(corpus){
  
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, content_transformer(tolower))
  corpus <- tm_map(corpus, removeNumbers)
  corpus <- tm_map(corpus, removeWords, stopwords("pt"))
  
  corpus
}

#and then proceed to apply it into the Corpora we are working with

noticias_corpus <- limpa_corpus(noticias_corpus)

#generating a matrix of documents-terms ("dtm") 
#it basically has each document in a row and each term in a column
#the content of the cell is the frequency of each document

dtm_noticias <- DocumentTermMatrix(noticias_corpus)
#opening a fragment
as.matrix(dtm_noticias[101:105, 311:315])

#taking a look at the terms with a frequency bigger than 500

findFreqTerms(dtm_noticias, 500)
