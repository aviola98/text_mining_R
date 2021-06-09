#tutorial 5

#stringr

library(dplyr)
library(rvest)
library(stringr)
library(readr)

#opening the data (collected in tutorial 3)
dados_noticias <- read_delim("https://raw.githubusercontent.com/thiagomeireles/cebraplab_captura_2021/main/dados/dados_noticias.csv", 
                             delim = ",", locale = locale(encoding = "WINDOWS-1252"))

#creating a new variable using only the date and not the time

dados_noticias <- dados_noticias %>%
  mutate(dia=str_extract_all(datahora, ".+?(?= às)")) %>%
  select(-datahora)

#changing .mai with 05

dados_noticias <- dados_noticias %>% 
  mutate(dia = str_replace_all(dia, ".mai.", "/05/"))

#transforming the variables in date

dados_noticias <- dados_noticias %>%
  mutate(dia=strptime(dia, "%d/%m/%Y"))


#let's excract the publications texts to a vector that we'll work with

noticias <- dados_noticias$texto

#checking the length of each publication

len_noticias <- str_length(noticias[1:100])

#dectecting the strings with bolsonaro and lula mentioned

str_detect(noticias, "Bolsonaro")
str_detect(noticias, "Lula")

#using string_subset in order to create a subgroup instead of a logical vector

noticias_bolsonaro <- str_subset(noticias, "Bolsonaro")
noticias_lula <- str_subset(noticias, "Lula")

#replacing news
#str_replace (replaces only the first occurence)
#str_replace_all replaces all the occurences

str_replace(noticias_bolsonaro[1:3], "Bolsonaro", "Bolsonaro, atual presidente do Brasil,")
str_replace(noticias_lula[1:3], "Lula", "Lula, potencial candidato em 2022,")


#knowing the position of the occurences of "Bolsonaro" and "Lula"
str_locate(noticias_bolsonaro, "Bolsonaro")
str_locate_all(noticias_bolsonaro,"Bolsonaro")

str_locate(noticias_lula, "Lula")
str_locate_all(noticias_lula, "Lula")

#news start always more or less in the same way
#let's remove the first 100 characters of each publication in order to observe them

str_sub(noticias[1:100], 1, 130)

#using len_noticias in order to excract the last 50 characters of each publication
str_sub(noticias[1:100], (len_noticias - 50), len_noticias)

#função wordcloud

install.packages(c("slam", "tm", "wordcloud"))


library(wordcloud)
wordcloud(noticias, max.words = 50)
wordcloud(noticias_lula, max.words = 50)
wordcloud(noticias_bolsonaro, max.words = 50)













