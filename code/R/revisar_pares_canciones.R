library(tidyverse)

trackMap <- read_tsv("../../data/trackMap.tsv",
                     col_names = c("new_id", "UUID"))

# canciones <- read_tsv("../../data/canciones_unicas.tsv",
#                       col_names = c("Artist", "UUID", "Song")) %>% 
#   inner_join(trackMap)
# 
# 
# canciones_metallica <- canciones %>% 
#   filter(grepl("Metallica", Artist))
# 
# canciones_rhcp <- canciones %>% 
#   filter(grepl("Red Hot Chil", Artist))
# 
artistas_unicos <- read_delim("../../data/artistas_unicos_bash.tsv",
                            col_names = c("UUID", "Artist"),
                            quote = "",
                            delim = "\t") %>% 
  left_join(trackMap)

### Artistas

artistas_parecidos_metallica <- read_tsv("../../data/artistas_parecidos_metallica.tsv", col_names = c("Artist_1", "new_id", "sim"))

artistas_parecidos_the_doors <- read_tsv("../../data/artistas_parecidos_the_doors.tsv", col_names = c("Artist_1", "new_id", "sim"))

artistas_parecidos_britney <- read_tsv("../../data/artistas_parecidos_britney_spears.tsv", col_names = c("Artist_1", "new_id", "sim"))

artistas_parecidos_pearl_jam <- read_tsv("../../data/artistas_parecidos_pearl_jam.tsv", col_names = c("Artist_1", "new_id", "sim"))


artistas_parecidos_metallica %>% 
  left_join(artistas_unicos) %>% 
  select(Artist, sim) %>% 
  arrange(desc(sim))

artistas_parecidos_the_doors %>% 
  left_join(artistas_unicos) %>% 
  select(Artist, sim) %>% 
  arrange(desc(sim))

artistas_parecidos_britney %>% 
  left_join(artistas_unicos) %>% 
  select(Artist, sim) %>% 
  arrange(desc(sim))

artistas_parecidos_pearl_jam %>% 
  left_join(artistas_unicos) %>% 
  select(Artist, sim) %>% 
  arrange(desc(sim))







