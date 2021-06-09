#webscraping exercise

library(rvest)
#storing the news URL in an object and then reading it using read_html and storing it into another object
url_noticia <- "https://datafolha.folha.uol.com.br/opiniaopublica/2021/01/1989199-73-defendem-urnas-eletronicas-e-23-querem-volta-do-voto-impresso.shtml"
pagina <- read_html(url_noticia)

#reading and storing the tile


title_node <- html_nodes(pagina, xpath = "//h1[@class = 'main_color main_title']")
title <- html_text(title_node)
print(title)

#reading and storing the date and time

date_time_nodes <- html_nodes(pagina, xpath = "//time")
date_time <- html_text(date_time_nodes)
print(date_time)

#reading and storing the pdf link (using html_attr)

pdf_nodes <- html_nodes(pagina, xpath="//p[@class = 'stamp download']/a")
pdf_link <- html_attr(pdf_nodes, name="href")
print(pdf_link)

#reading and storing the text (using p at the end of the path because we want to get rid of the spam)

text_nodes <- html_nodes(pagina, xpath ="//article[@class = 'news']/p")
text_pagina <- html_text(text_nodes)
print(text_pagina)

#joining the text

text_pagina <- paste(text_pagina, collapse=" ")

print(text_pagina)