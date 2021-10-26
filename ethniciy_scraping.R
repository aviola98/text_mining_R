library(rvest)
library(tidyverse)
library(openxlsx)

url <- "https://pt.wikipedia.org/wiki/Lista_das_contas_mais_seguidas_no_Instagram"
pagina <- read_html(url)
print(pagina)

tabelas_wiki <- html_table(pagina)
class(tabelas_wiki)
str(tabelas_wiki)

tabela_accounts <- tabelas_wiki[[1]]


tabela_accounts <- tabela_accounts %>%
  rename("position"="Posição",
         "username"="Nome de usuário",
         "name"="Proprietário",
         "country"="País")

tabela_accounts <- tabela_accounts %>%
  select(position,username,name,country)

write.xlsx(tabela_accounts,"tabela_accounts.xlsx")
