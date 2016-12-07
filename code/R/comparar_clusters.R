library(igraph)
library(tidyverse)
library(dplyr)
library(devtools)
library(Rspotify)
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
  return (matched)
}
 
###########################################################
# Se obtiene el genero de un artista 
###########################################################
get_genres <- function(artist_name) {
  artist_name <- strsplit(artist_name, '_')[[1]][2]
  artist_name <-gsub(" ", "+", artist_name)
  #api Spotify: 
  artist_info <- searchArtist(artist_name)
  return (artist_info$genres[[1]])
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

#for (i in 1:14) {
  group_list  <- get_head_by_id("1", cluster)
  genre_list  = c()
  i <- 1
  for (item in group_list){
    genre_list <- c(genre_list,get_genres(item))
  }
  genre_table <- tail(sort(prop.table(table(genre_list))),n=7)
  barplot( genre_table, names.arg=gsub("\\s","\n", rownames(genre_table)))
#}
#Porcentaje de artistas relacionados 
x = array(list(), 14)
for (i in 1:14 ){
  x[[i]] <- get_group_by_id(toString(i),cluster)
}



