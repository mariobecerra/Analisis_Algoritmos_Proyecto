library(tidyverse)

axis_labels_vert <- function() theme(axis.text.x = element_text(angle = 90, hjust = 1))

clusters <- read_rds("../../out/communities_artists_df.rds")
# generos <- read_rds("../../out/generos.rds") %>% 
#   mutate(genre_list = as.character(genre_list))

generos <- read_rds("../../out/gn_1.rds") %>% 
  bind_rows(read_rds("../../out/gn_2.rds")) %>% 
  bind_rows(read_rds("../../out/gn_3.rds")) %>% 
  bind_rows(read_rds("../../out/gn_4.rds")) %>% 
  bind_rows(read_rds("../../out/gn_5.rds")) %>% 
  bind_rows(read_rds("../../out/gn_6.rds")) %>% 
  bind_rows(read_rds("../../out/gn_7.rds")) %>% 
  bind_rows(read_rds("../../out/gn_8.rds")) %>% 
  bind_rows(read_rds("../../out/gn_9.rds")) %>% 
  bind_rows(read_rds("../../out/gn_10.rds")) %>% 
  bind_rows(read_rds("../../out/gn_11.rds")) %>% 
  bind_rows(read_rds("../../out/gn_12.rds")) %>% 
  bind_rows(read_rds("../../out/gn_13.rds")) %>% 
  bind_rows(read_rds("../../out/gn_14.rds"))

(generos %>% 
  group_by(cluster) %>% 
  top_n(10, number_artists) %>% 
  ungroup() %>% 
  mutate(genre_list = factor(genre_list, levels = genre_list)) %>% 
  ggplot() +
  geom_bar(aes(x = genre_list, y = number_artists), 
           stat = 'identity') +
  facet_wrap(~cluster, scales = 'free', ncol = 7) + 
  theme_bw() +
  axis_labels_vert()) %>% ggsave(filename = "../../out/generos_plot_1.png", plot = ., height = 26, width = 55, units = "cm")



(generos %>% 
  group_by(cluster) %>% 
  top_n(10, number_artists) %>% 
  ungroup() %>% 
  mutate(genre_list = factor(genre_list, levels = genre_list)) %>% 
  ggplot() +
  geom_bar(aes(x = genre_list, y = number_artists), 
           stat = 'identity') +
  facet_wrap(~cluster, scales = 'free', ncol = 3) + 
  theme_bw() +
  axis_labels_vert() +
  ylab("") +
  xlab("Géneros")
) %>% 
  ggsave(filename = "../../out/generos_plot_2.png", 
         plot = ., height = 27, width = 13, units = "cm")



(clusters %>% 
  group_by(community) %>% 
  tally() %>% 
  ggplot() + 
  geom_bar(aes(community, n), 
           stat = 'identity') + 
  theme_bw() + 
  ylab("Número de artistas") + 
  xlab("Comunidad")
) %>% 
  ggsave(filename = "../../out/artistas_por_comunidad.png", .,
         height = 8, width = 10, units = "cm")



clusters %>% 
  select(community, Artist, number_of_plays) %>% 
  group_by(community) %>% 
  top_n(30, number_of_plays) 

clusters %>% 
  group_by(community) %>% 
  top_n(10, number_of_plays) %>% 
  select(community, Artist) %>% 
  mutate(Artist = stringi::stri_extract_all(Artist, 
                                            regex = "\\_(.*)")) %>%
  mutate(Artist =  stringi::stri_replace_all(Artist, 
                                             replacement = "", 
                                             fixed = "_")) %>% 
  group_by(community) %>% 
  View



  
  
  