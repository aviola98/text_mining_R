library(rvest)
library(dplyr)
library(stringr)


url_base <-  "https://search.folha.uol.com.br/search?q=coronavirus&site=todos&periodo=todos&results_count=10000&search_time=0%2C025&url=https%3A%2F%2Fsearch.folha.uol.com.br%2Fsearch%3Fq%3Dcoronavirus%26site%3Dtodos%26periodo%3Dtodos&sr="

#loop in order to iterate through the first 300 pages
#keep in mind that the news page is organized with 25 news each 
for (i in 1:12){
  i <- (i - 1) * 25 + 1
  print(i)
}

url_search <- paste(url_base,1,sep="")

#capturing the html of the page

pagina <- read_html(url_search)

#choosing only the nodes that are interesting to us

nodes_titulos <- html_nodes(pagina, xpath = "//h2[@class = 'c-headline__title']")
nodes_link <- html_nodes(pagina, xpath = "//*[@id='view-view']/div/div/a")

#let's exctract the titles and links with the appropriate functions

titulos <- html_text(nodes_titulos) %>%
  str_squish()

links <- html_attr(nodes_link, name="href")
links <- unique(links)
#keeping all the links that do not have photos 
links <- links[!grepl("#foto-",links)]

#combining the two vectors within a data frame

table_titulos <- tibble(titulos, links)
View(table_titulos)

#using bind_row in order to combine data frames
#uniting the 25 results of each of the 12 pages


data_research <- tibble()
data_research <- bind_rows(data_research, table_titulos)

#long ass loop

url_base <-  "https://search.folha.uol.com.br/search?q=coronavirus&site=todos&periodo=todos&results_count=10000&search_time=0%2C025&url=https%3A%2F%2Fsearch.folha.uol.com.br%2Fsearch%3Fq%3Dcoronavirus%26site%3Dtodos%26periodo%3Dtodos&sr="

data_research <- tibble()

for (i in 1:12){
  
  print(i)
  
  x <- (i - 1) * 25 + 1
  
  url_pesquisa <- paste(url_base, x, sep = "")
  
  pagina <- read_html(url_pesquisa)
  
  nodes_titulos <- html_nodes(pagina, xpath = "//h2[@class = 'c-headline__title']")
  nodes_links <- html_nodes(pagina, xpath = "//*[@id='view-view']/div/div/a")
  
  titulos <- html_text(nodes_titulos) %>% 
    str_squish()
  
  titulos <- unique(titulos)
  
  links <- html_attr(nodes_links, name = "href")
  links <- unique(links)
  links <- links[!grepl("#foto-", links)]
  
  if(length(titulos)!=length(links)){
    links <- links[!grepl("/galerias/", links)]
  }
  
  tabela_titulos <- tibble(titulos, links)
  
  data_research <- bind_rows(data_research, tabela_titulos)
  
}

#now we have to capture the content of each page whose content is stored in the links vector

#loop 
for (link in data_research$links){
  print(link)
}


#only taking the first 100 news

#creating an empty tibble where we'll store the data 
dados_noticias <- tibble()

#loop 
#we have a link variable which gets at teach iteration an URL address in order
#these addresses are stored in the links variable created in the database above

for (link in data_research$links[1:100]){

   #printing the link 
  print(link)
  
  #reading the link using the function read_html and storing it in the variable "pagina"
  pagina <- read_html(link)
  #reading the nodes in "pagina" using html_nodes and storing them in the node_titulo variable
  node_titulo <- html_nodes(pagina, xpath = "//h1[@class = 'c-content-head__title']")
  #reading the title of the news from the nodes using the function html_text and cleaning it using squish
  titulo <- html_text(node_titulo) %>%
    str_squish()
  
  if(length(titulo)==0){
    titulo <- data_research$titulos[data_research$links==link]
  }
  
  node_subtitulo <- html_nodes(pagina, xpath = "//h2[@class = 'c-content-head__subtitle']")
  subtitulo <- html_text(node_subtitulo) %>% 
    str_squish()
  
  node_datahora <- html_nodes(pagina, xpath = "//div[5]//time")
  datahora <- html_text(node_datahora) %>% 
    str_squish()
  
  node_texto <- html_nodes(pagina, xpath = "//article[@class = 'c-news']//div[5]//p")
  texto <- html_text(node_texto) %>% 
    str_squish()
  texto <- texto[texto!=""]
  texto <- paste(texto, collapse = " ")
  texto <- str_split(texto, "Recurso exclusivo para assinantes")[[1]][1] 
  
  tabela_noticia <- tibble(titulo, subtitulo, datahora, texto)
  
  dados_noticias <- bind_rows(dados_noticias, tabela_noticia)
  
}

View(dados_noticias)



















