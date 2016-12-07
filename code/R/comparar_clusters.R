library(igraph)
library(tidyverse)
library(dplyr)
library(devtools)
library(Rspotify)
library(reshape)
keys <- spotifyOAuth("proyecto_cairo","e0eada50949046f6a3900bc057a2d26e","546ec83e63224d798f3da7edc4845fea")

cluster <- readRDS("../../out/communities_artists_df.rds") 

############################################################
#
#
#                   FUNCIONES 
#
#
############################################################


###########################################################
#
# Se toma el artista con mayor numero de reproducciones del 
# cluster dado por el parametro idx
# Se pregunta a spotify cuales son los artistas relacionados 
# Se buscan los artistas de spotify en el cluster 
# Regresa la lista de  los elementos que coincidieron 
#
###########################################################
get_group_by_id <- function(idx, data) {
  group_cluster <- dplyr::filter(data, community %in% c(idx))
  group_sort <- group_cluster[order(-group_cluster$number_of_plays),] 
  
  artist_name <- strsplit(group_sort$Artist, '_')[[1]][2]
  matched <- c(artist_name)
  artist_name <-gsub(" ", "+", artist_name)
  #api Spotify: 
  related_artist<-getRelated(artist_name)
  spotify_artists <- related_artist$names 
  
  cluster_artists <- colsplit(group_sort$Artist, split="_", c("idx","name"))$name 
  for (item in spotify_artists) {
    item_to_search <- item
    if (item_to_search %in% cluster_artists) {
      matched<-c(matched,item_to_search)
    }
  }
  return (spotify_artists )
}
 
###########################################################
# Se obtiene el genero de un artista 
###########################################################
get_genres <- function(artist_name) {
  artist_name <- strsplit(artist_name, '_')[[1]][2]
  artist_name <-gsub(" ", "+", artist_name)
  #api Spotify: 
  artist_info <- searchArtist(artist_name)
  print(artist_info)
  result <- try(artist_info$genres[[1]]);
  
  if (class(result) == "try-error") {
    return (result)
  }
  return( c())
}
###########################################################
#
# Regresa un df con los generos de un cluste
#
###########################################################

get_cluster_df <- function (idx) {
  group_list  <- get_head_by_id(toString(idx), cluster)
  genre_list  = c()
  
  for (item in group_list){
    tmp <- get_genres(item)
    if (length(tmp) >= 1) {
      genre_list <- c(genre_list, tmp)
    }
  }
  
  generos <-data.frame(genre_list)
  gn <- generos %>% 
    group_by(genre_list) %>% 
    summarise(number_artists = n()) %>%
    arrange(desc(number_artists))
  gn['cluster'] = idx
  return(gn)
}

###########################################################
#
# Regresa la lista de nombres de los artistas mas populares.
# los primeros size
#
###########################################################
get_head_by_id <- function(idx, data, size=20) {
  group_cluster <- dplyr::filter(data, community %in% c(idx))
  group_sort <- group_cluster[order(-group_cluster$number_of_plays),] 
  return(head(group_sort$Artist, size))
}

##########################################################
#
#                       PRUEBA
#
#########################################################

#Grafica de distribucion por cluster
g_all <- data.frame()

for (i in 1:14 ){
  g_all <-rbind(g_all,get_cluster_df(i))
  
}

saveRDS(g_all, "../../out/generos.rds")


#Porcentaje de artistas relacionados 
x = array(list(), 14)
for (i in 1:14 ){
  x[[i]] <- get_group_by_id(toString(i),cluster)
}

total <- 0
for (i in 1:14 ){
  total <- total + length(x[[i]])
}








