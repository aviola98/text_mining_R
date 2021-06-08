#tutorial1
library(rvest)
if (!require("tidyverse")) install.packages("tidyverse"); library(tidyverse)


#in order to capture the page we use read_html

url <- "https://pt.wikipedia.org/wiki/Lista_de_pa%C3%ADses_e_territ%C3%B3rios_por_%C3%A1rea"
page <- read_html(url)
print(page)

#extracting the tables

wiki_tables <- html_table(page)

class(wiki_tables)
str(wiki_tables)
#we have just generated a list with the 7 tables available

#Exctrating infortmation from Folha de SP

url_base <- "https://search.folha.uol.com.br/search?q=coronavirus&site=todos&periodo=todos&results_count=10000&search_time=0%2C025&url=https%3A%2F%2Fsearch.folha.uol.com.br%2Fsearch%3Fq%3Dcoronavirus%26site%3Dtodos%26periodo%3Dtodos&sr=26"

#capturing only the page 2

for (i in 1:9) {
  print(i)
}

#seven times table

for (i in 1:9) {
  print(i * 7)
}

for (i in 3:15) {
  print(i*10)
}

#gsub function (it allows to replace a piece of string object by another from a specified criteria)

#what_i_want_to_replace <- "word"
#what_i_want_to_replace_for <- "potato"
#my_text <- "i want to replace this word"

#final_text <- gsub(what_i_want_to_replace,what_i_want_to_replace_for,my_text)
#print(final_text)

url_base <- "https://search.folha.uol.com.br/search?q=coronavirus&site=todos&periodo=todos&results_count=10000&search_time=0%2C025&url=https%3A%2F%2Fsearch.folha.uol.com.br%2Fsearch%3Fq%3Dcoronavirus%26site%3Dtodos%26periodo%3Dtodos&sr=REFERENCIA"

#generating a link for page 3

url <- gsub("REFERENCIA","51",url_base)
print(url)

#we can alternatively use a vector
i<-51
url<- gsub("REFERENCIA",i, url_base)
print(url)

#exctracting the countries with more than a million square areas in a dataframe
gigants <- wiki_tables[[1]]
head(gigants)

#using bind_rows to bind different data frames putting its lines one under another

# Criando 2 data frames separados
library(dplyr)
meus.dados1 <- data_frame("id" = 1:10, "Experimento" = rep(c("Tratamento"), 10))
print(meus.dados1)

meus.dados2 <- data_frame("id" = 11:20, "Experimento" = rep(c("Controle"), 10))
print(meus.dados2)

# Combinando os dois data.frames
meus.dados.completos <- bind_rows(meus.dados1, meus.dados2)
print(meus.dados.completos)

#creating a dataframe with all the captured tables 

data <- tibble()

for (i in c(1:6)) {
  print(i)
  
  table <- wiki_tables[[i]]
  
  colnames(table)[3] <- "Área (Km)2"
  
  table <- table %>%
    mutate(Ordem = as.character(Ordem))
  
  data <- bind_rows(data,table)
}

str(data)
head(data)
tail(data)
View(data)
