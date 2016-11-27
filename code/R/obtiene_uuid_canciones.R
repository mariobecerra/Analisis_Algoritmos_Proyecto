library(tidyverse)

canciones <- read_tsv("../../data/userid-timestamp-artid-artname-traid-traname.tsv", col_names = F)

canciones_unicas <- canciones %>% 
  filter(!is.na(X5)) %>% 
  select(X4, X5, X6) %>% 
  unique(.) %>% 
  arrange(X4)

write_tsv(canciones_unicas, 
          "../../data/canciones_unicas.tsv",
          col_names = F)