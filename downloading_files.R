#Downloading files

url_noticia <- "https://datafolha.folha.uol.com.br/eleicoes/2021/05/1989295-lula-lidera-com-41-no-1-turno-e-tem-vantagem-sobre-bolsonaro-23.shtml"
pagina <- read_html(url_noticia)
node_pdf <- html_nodes(pagina, xpath = "//p[@class = 'stamp download']/a")
link_pdf <- html_attr(node_pdf, name = "href")

print(link_pdf)

#finding out what's my working directory
getwd()

#setdw("~/pdfs")
#downloading using the function download.file
download.file(link_pdf, "pesquisa.pdf", mode = 'wb')

