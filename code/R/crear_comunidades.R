library(igraph)
library(tidyverse)

similitudes <- readRDS("../../out/similitudes.rds") %>% .$sim
grafo_sims <- readRDS("../../out/grafo_sims.rds")

cat("Empieza a calcular clusters", 
    "\n",
    "Hora:",
    as.character(Sys.time()),
    file = "../../out/0.log")

clusters <- cluster_louvain(grafo_sims, weights = similitudes)

saveRDS(clusters, "../../out/clusters.rds")

cat("Terminó de calcular clusters", 
    "\n",
    "Hora:",
    as.character(Sys.time()),
    file = "../../out/1.log")

