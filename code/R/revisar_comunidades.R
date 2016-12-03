library(igraph)
library(tidyverse)

clusters <- readRDS("../../out/clusters.rds")
similitudes <- readRDS("../../out/similitudes.rds") %>% .$sim
grafo_sims <- readRDS("../../out/grafo_sims.rds")
artists_plays <- read_rds("../../out/artists_plays.rds")

communities_artists <- communities(clusters)

degrees_sims <- degree(grafo_sims)

degrees_sims_df <- tibble(Artist = names(degrees_sims),
                          degree = degrees_sims) %>% 
  arrange(desc(degree))

communities_artists_df <- lapply(1:length(communities_artists), function(i) {
  df <- tibble(community = i,
               Artist = communities_artists[[i]])
  return(df)
}) %>% 
  bind_rows() %>% 
  left_join(artists_plays %>% 
              select(Artist, number_of_plays, number_of_users_listened))

saveRDS(communities_artists_df, "../../out/communities_artists_df.rds")

communities_artists_df %>% group_by(community) %>% top_n(n = 30, wt = number_of_plays) %>% View

