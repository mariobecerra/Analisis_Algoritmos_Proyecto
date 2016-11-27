library(tidyverse)

canciones <- read_tsv("../../data/canciones_unicas.tsv",
                      col_names = c("Artist", "UUID", "Song"))

canciones_metallica <- canciones %>% 
  filter(grepl("Metallica", Artist))

canciones_rhcp <- canciones %>% 
  filter(grepl("Red Hot Chil", Artist))

