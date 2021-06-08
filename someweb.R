#exctracting the url 
url_exercise <- "https://www1.folha.uol.com.br/poder/2021/05/aliados-de-bolsonaro-reforcam-polarizacao-e-atacam-lula-apos-atos-contra-presidente.shtml"

page_exercise <- read_html(url_exercise)

#excracting the title

title_ex_node <- html_nodes(page_exercise, xpath = "//h1[@class = 'c-content-head__title']")

title_ex <- html_text(title_ex_node) %>%
  str_squish()

print(title_ex)

#excracting the subtitle

subtitle_node <- html_nodes(page_exercise, xpath= "//h2[@class = 'c-content-head__subtitle']")

subtitle_ex <- html_text(subtitle_node) %>%
  str_squish()

print(subtitle_ex)

#excracting date and time

date_time_node_ex <- html_nodes(page_exercise, xpath = "//div[5]//time")

date_time_ex <- html_text(date_time_node_ex) %>%
  str_squish()

print(date_time_ex)

#excracting the text

news_ex_nodes <- html_nodes(page_exercise, xpath = "//article[@class = 'c-news']//div[5]//p")

news_ex <- html_text(news_ex_nodes) %>%
  str_squish()

#cleaning the text
news_ex <- news_ex[news_ex!=""]
news_ex<- paste(news_ex, collapse=" ")
news_ex <- str_split(news_ex, "Recurso exclusivo para assinantes")[[1]][1]

print(news_ex)

