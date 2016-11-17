# -*- coding: utf-8 -*-

path = '/Users/tania/source/itam/maestria/Analisis_Algoritmos_Proyecto/data/lastfm-dataset-1K'


## Maps are created with scripts
user_map = sc.textFile(
                    path + '/userMap.tsv'
                  ).map(
                    lambda line: line.split('\t')
                  ).map(lambda l: (l[1],l[0]))

track_map = sc.textFile(
                    path + '/trackMap.tsv'
                  ).map(
                    lambda line: line.split('\t')
                  ).map(lambda l: (l[1],l[0]))

play_history = sc.textFile(
                    path + '/userid-trackid.tsv'
                  ).map(
                    lambda line: line.split('\t')
                  ).filter(
                    lambda (user,track): track!=''
                  ).join( ## user and track ids need to be mapped to integers
                    user_map
                  ).map(
                    lambda (user_id,(track_id,user_int)): (track_id,user_int)
                  ).join(
                    track_map
                  ).map(
                    lambda (track_id,(user_int, track_int)): (user_int,track_int) )                

user_track_count = play_history.map(
                          lambda (user,track): ((user,track),1)
                        ).reduceByKey(lambda a,b: a+b)

user_track_count.map(
      lambda ((user,track),count): user + '\t' + track + '\t' + str(count)
    ).saveAsTextFile(path + "/plays-matrix")


##################
#  Histograms
##################
user_track_count = sc.textFile(path + "/plays-matrix.tsv").map(
                    lambda line: [int(x) for x in line.split('\t')]
                  )

distinct_users = user_track_count.map(
  lambda (user,track,count): user)

distinct_users.histogram([0, 10, 50, 100,500,990,995])

distinct_tracks = user_track_count.map(
  lambda (user,track,count): track)

distinct_tracks.histogram([0, 10, 50, 100,500,990,995])

#################################################
#  Eliminar usuarios y tracks 'sin importancia'
#################################################

distinct_users = distinct_users.map(
  lambda x: (x,1)
).reduceByKey(lambda a,b: a+b).filter(lambda (x,c): c > 25)

distinct_tracks = distinct_tracks.map(
  lambda x: (x,1)
).reduceByKey(lambda a,b: a+b).filter(lambda (x,c): c > 10)




###############################

from pyspark.mllib.recommendation import ALS, MatrixFactorizationModel, Rating

user_track_count = sc.textFile(
                      path + "/plays-matrix.tsv"
                    ).map(
                      lambda line: line.split('\t')
                    ).map(lambda (u,t,c): (int(u),(int(t),int(c))))

filtered_user_track_count = user_track_count.join(
    distinct_users
  ).map(
    lambda (user,((track,count),j)): (track,(user,count))
  ).join(
    distinct_tracks
  ).map(
    lambda (track,((user,count),j)): ((user,track),count)
  )


ratings = filtered_user_track_count.map(
              lambda ((user,track),count): Rating(user, track, float(count)))

# Build the recommendation model using Alternating Least Squares
rank = 50
numIterations = 10
model = ALS.trainImplicit(ratings, rank, numIterations)
prod_features = model.productFeatures()
prod_features.map(
    lambda l: str(l[0]) + '\t' + (','.join(str(i) for i in l[1]))
  ).saveAsTextFile(path + "/prod-features-50")

##############################

path = '/Users/tania/source/itam/maestria/Analisis_Algoritmos_Proyecto/data/lastfm-dataset-1K'
from scipy.spatial.distance import cosine

prod_features = sc.textFile(
                  path + "/prod-features-50.tsv"
                ).map(
                  lambda line: line.split('\t')
                ).map(
                  lambda (prod_id,features_str): (int(prod_id),[float(x) for x in features_str.split(',')])
                )
similarities = prod_features.cartesian(
                  prod_features
                ).filter(
                  lambda ((k1,v1),(k2,v2)): k1<k2
                ).map(
                  lambda ((k1,v1),(k2,v2)): ((k1,k2),1-cosine(v1,v2))
                )
similarities.map(lambda ((k1,k2),sim): str(k1) + '\t' + str(k2) + '\t' + str(sim) 
                  ).saveAsTextFile(path + "/similarities-50")     


