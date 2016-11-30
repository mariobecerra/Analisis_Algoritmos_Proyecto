library(tidyverse)

# canciones <- read_tsv("../../data/lastfm-dataset-1K/userid-timestamp-artid-artname-traid-traname.tsv", col_names = F)

canciones <- read.table("../../data/lastfm-dataset-1K/userid-timestamp-artid-artname-traid-traname.tsv", header = F, stringsAsFactors = F, quote = "", na.strings = "", sep = "\t", comment.char = "")

trackMap <- read_tsv("../../data/trackMap.tsv",
                     col_names = c("new_id", "UUID"))

artistas_unicos <- canciones %>% 
  select(UUID = X3, Artist = X4) %>% 
  unique(.) %>% 
  arrange(Artist) %>% 
  left_join(trackMap)

canciones_unicas <- canciones %>% 
  #filter(!is.na(X5)) %>% 
  select(X4, X5, X6) %>% 
  unique(.) %>% 
  arrange(X4)

write_tsv(canciones_unicas, 
          "../../data/canciones_unicas.tsv",
          col_names = F)

write_tsv(artistas_unicos, 
          "../../data/artistas_unicos.tsv",
          col_names = F)