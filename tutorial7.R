#tutorial 7

#tidytext

library(readr)

dados_noticias <- read_delim("https://raw.githubusercontent.com/thiagomeireles/cebraplab_captura_2021/main/dados/dados_noticias2.csv", 
                             delim = ";", locale = locale(encoding = "WINDOWS-1252"))

noticias <- dados_noticias$texto

#since in R with have a tendency to left everything tidy

library(tidytext)
library(dplyr)
library(ggplot2)
library(tidyr)
library(tm)
library(wordcloud)

#let's re-create the dataframe with the publications

noticias_df <- tibble(doc_id = as.character(1:length(noticias)), 
                      text = noticias)

glimpse(noticias_df)

#tokenization

noticias_token <- noticias_df %>%
  unnest_tokens(word, text)

glimpse(noticias_token)

#creating a dataframe with the stopwords

stopwords_pt <- c(stopwords("pt"), "sobre", "após", "folha", "nesta", "u", "é", "ser")

stopwords_pt_df <- tibble(word = stopwords_pt)

#with anti_join we keep only the words that aren't in the list created above
noticias_token <- noticias_token %>%
  anti_join(stopwords_pt_df, by="word")

#using a regular expression in order to remove the remaining numbers

noticias_token <- noticias_token %>%
  filter(!grepl("[0-9]", word))

#in order to observe the frequency of words in the news we use count

noticias_token %>%
  count(word, sort=T)

#creating a graph with the 10 most frequent terms

noticias_token %>%
  count(word, sort = TRUE) %>%
  top_n(10) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot(aes(word, n)) +
  geom_col(aes(fill = word)) +
  xlab(NULL) +
  labs(y = "Número de ocorrências",
       x = "Termos") +
  coord_flip() +
  theme_bw() +
  theme(legend.position = "none")

#incorporating the function wordcloud() into our analysis

noticias_token %>%
  count(word, sort = TRUE) %>%
  with(wordcloud(word, n, max.words = 50))


#it is useful to work with bigrams(token with 2 words) or ngrams(token with n words)
#if you do not want to convert to lower case use to_lower=F
publicacao_bigrams <- noticias_df %>%
  unnest_tokens(bigram, text, token = "ngrams", n = 2)

#counting the bigrams
publicacao_bigrams %>%
  count(bigram, sort = TRUE)

#excluding stopwords in bigrams
#separating the bigrams and two words one in each column

bigrams_separated <- publicacao_bigrams %>%
  separate(bigram, c("word1", "word2"), sep = " ")
#then we filter the dataframe excluding the stopwords
#reusing the vector stopwords_pt

bigrams_filtered <- bigrams_separated %>%
  filter(!word1 %in% stopwords_pt,
         !word2 %in% stopwords_pt,
         !grepl("[0-9]", word1),
         !grepl("[0-9]", word2))

#we can also filter the bigram using anti_join
bigrams_filtered <- bigrams_separated %>%
  anti_join(stopwords_pt_df, by = c("word1" = "word")) %>%
  anti_join(stopwords_pt_df, by = c("word2" = "word")) %>% 
  filter(!grepl("[0-9]", word1),
         !grepl("[0-9]", word2))

#frequency of bigrams after the filter
bigram_counts <- bigrams_filtered %>% 
  count(word1, word2, sort = TRUE)

#joining the separated words
bigrams_united <- bigrams_filtered %>%
  unite(bigram, word1, word2, sep = " ")

#let's see which words antecipate Bolsonaro
bigrams_filtered %>%
  filter(word2 == "bolsonaro") %>%
  count(word1, sort = TRUE)
#let's see which words come after bolsonaro
bigrams_filtered %>%
  filter(word1 == "bolsonaro") %>%
  count(word2, sort = TRUE)


#or both 

bf1 <- bigrams_filtered %>%
  filter(word2 == "bolsonaro") %>%
  count(word1, sort = TRUE) %>%
  rename(word = word1)

bf2 <- bigrams_filtered %>%
  filter(word1 == "bolsonaro") %>%
  count(word2, sort = TRUE) %>%
  rename(word = word2)

bind_rows(bf1, bf2) %>%
  arrange(-n)

#repeating the process with trigrams

noticias_df %>%
  mutate(text = removeNumbers(text)) %>% 
  unnest_tokens(trigram, text, token = "ngrams", n = 3) %>%
  separate(trigram, c("word1", "word2", "word3"), sep = " ") %>%
  anti_join(stopwords_pt_df, by = c("word1" = "word")) %>%
  anti_join(stopwords_pt_df, by = c("word2" = "word")) %>%
  anti_join(stopwords_pt_df, by = c("word3" = "word")) %>%
  count(word1, word2, word3, sort = TRUE)

#text web

library(igraph)
library(ggraph)

#transforming the dataframe into an object of class igraph

set.seed(123)

bigram_graph <- bigram_counts %>%
  filter(n > 15) %>%
  graph_from_data_frame()

#doing a graph from the bigrams 

ggraph(bigram_graph, layout = "fr") +
  geom_edge_link() +
  geom_node_point() +
  geom_node_text(aes(label = name), vjust = 1, hjust = 1)