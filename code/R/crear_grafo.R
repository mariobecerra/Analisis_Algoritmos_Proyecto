library(igraph)
library(tidyverse)

trackMap <- read_tsv("../../data/trackMap.tsv",
                     col_names = c("new_id", "UUID"))

artistas_unicos <- read_delim("../../data/artistas_unicos_bash.tsv",
                              col_names = c("UUID", "Artist"),
                              quote = "",
                              delim = "\t") %>% 
  left_join(trackMap) %>% 
  select(new_id, Artist) %>% 
  filter(!is.na(new_id)) %>% 
  filter(!duplicated(new_id))

similitudes <- read_tsv("../../data/filtered-similarities-50.tsv",
                        col_names = F)

similitudes_2 <- similitudes %>% 
  left_join(artistas_unicos, by = c("X1" = "new_id")) %>% 
  left_join(artistas_unicos, by = c("X2" = "new_id")) %>% 
  mutate(Artist.x = paste0(X1, "_", Artist.x),
         Artist.y = paste0(X2, "_", Artist.y)) %>% 
  select(Artist.x, Artist.y, sim = X3)

saveRDS(similitudes_2, "../../out/similitudes.rds")

grafo_sims <- graph_from_edgelist(as.matrix(similitudes_2[,1:2]),
                                  directed = F)

#grafo_sims <- graph.data.frame(similitudes_2, directed = F)

saveRDS(grafo_sims, "../../out/grafo_sims.rds")