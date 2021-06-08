#capturing data using HTML

url <-  "https://search.folha.uol.com.br/search?q=coronavirus&site=todos&periodo=todos&results_count=10000&search_time=0%2C025&url=https%3A%2F%2Fsearch.folha.uol.com.br%2Fsearch%3Fq%3Dcoronavirus%26site%3Dtodos%26periodo%3Dtodos&sr=26"

page <- read_html(url)

class(page)

#capturing the nodes

title_nodes <- html_nodes(page, xpath =  "//ol/li/div/div/a/h2[@class = 'c-headline__title']")

print(title_nodes)

#now that we have the nodes with the titles we use html_text to capture these titles

titles <- html_text(title_nodes)

#identifying and removing undesired characters

titles[[1]]

library(stringr)

titles <- str_squish(titles)

titles[[1]]

#a tag can contain more than one attribute so we use the argument name from the function html_attr in order to specify which attribute we want
#using unique to keep 25 values unique , avoiding title duplication

nodes_links <- html_nodes(page, xpath = "//*[@id='view-view']/div/div/a")

links <- html_attr(nodes_links, name = "href")

links <- unique(links)

table_titles <- data.frame(titles, links)

View(table_titles)
