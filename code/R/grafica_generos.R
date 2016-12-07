library(tidyverse)

axis_labels_vert <- function() theme(axis.text.x = element_text(angle = 90, hjust = 1))

clusters <- read_rds("../../out/communities_artists_df.rds")
generos <- read_rds("../../out/generos.rds") %>% 
  mutate(genre_list = as.character(genre_list))

generos %>% 
  group_by(cluster) %>% 
  top_n(10, number_artists) %>% 
  ungroup() %>% 
  mutate(genre_list = factor(genre_list, levels = genre_list)) %>% 
  ggplot() +
  geom_bar(aes(x = genre_list, y = number_artists), 
           stat = 'identity') +
  facet_wrap(~cluster, scales = 'free') + 
  axis_labels_vert()

