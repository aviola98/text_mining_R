library(tidyverse)
library(openxlsx)
library(readxl)

ethnicity <- read_excel("tabela_accounts.xlsx")

ethnicity <-
ethnicity %>%
  mutate(continent=case_when(country=="Estados Unidos"~"América",
                             country=="Brasil"~"América",
                             country=="Argentina"~"América",
                             country=="Trindade e Tobago"~"América",
                             country=="Canada"~"América",
                             country=="Barbados"~ "América",
                             country=="Canadá"~"América",
                             country=="Colômbia"~"América",
                             country=="Portugal"~"Europa",
                             country=="Espanha"~"Europa",
                             country=="União Europeia"~"Europa",
                             country=="Reino Unido"~"Europa",
                             country=="Índia"~"Ásia",
                             country=="Israel"~"Ásia"
                             )) %>%
  select(position,username,name,country,continent)

ethnicity %>%
  group_by(continent) %>%
  count(continent) %>%
  ggplot()+
  geom_col(aes(x=continent,
               y=n,
               fill=continent))

ethnicity %>%
  group_by(country) %>%
  count(country) %>%
  ggplot()+
  geom_col(aes(x=country,
               y=n,
               fill=country))

ethnicity %>%
  group_by(country) %>%
  count(country) %>%
  arrange(-n)
