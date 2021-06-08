#web-scraping folha

library(rvest)
library(dplyr)
library(stringr)

news_url <- "https://www1.folha.uol.com.br/equilibrioesaude/2021/05/durante-pandemia-de-covid-19-cardiologista-aplica-metodo-antifumo-que-associa-medicacao-a-castigo.shtml"
page <- read_html(news_url)

#exctracting the title
title_node <- html_nodes(page, xpath = "//h1[@class = 'c-content-head__title']")

title <- html_text(title_node) %>% 
  str_squish()
print(title)

#exctracting the subtitle
sub_tite_node <- html_nodes(page, xpath= "//h2[@class = 'c-content-head__subtitle']")

subtitle <- html_text(sub_tite_node) %>%
  str_squish()

print(subtitle)

#exctracting date and time

node_date_time <- html_nodes(page, xpath = "//div[5]//time")

date_time <- html_text(node_date_time) %>%
  str_squish()

date_time

#web scraping the text

node_text <- html_nodes(page, xpath = "//article[@class = 'c-news']//div[5]//p")

text <- html_text(node_text) %>%
  str_squish()

print(text)

text <- text[text!=""]
text<- paste(text, collapse=" ")
text <- str_split(text, "Recurso exclusivo para assinantes")[[1]][1]
print(text)
