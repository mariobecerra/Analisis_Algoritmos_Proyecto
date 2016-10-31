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

from pyspark.mllib.recommendation import ALS, MatrixFactorizationModel, Rating
from scipy.spatial.distance import cosine

ratings = user_track_count.map(
              lambda ((user,track),count): Rating(int(user), int(track), float(count)))

# Build the recommendation model using Alternating Least Squares
rank = 200
numIterations = 10
model = ALS.trainImplicit(ratings, rank, numIterations)
prod_features = model.productFeatures()
prod_features.map(
                    lambda l: str(l[0]) + '\t' + (','.join(str(i) for i in l[1]))
                  ).saveAsTextFile(path + "/prod-features-200")
similarities = prod_features.cartesian(prod_features).map(lambda ((k1,v1),(k2,v2)): ((k1,k2),1-cosine(v1,v2)))
similarities.map(lambda ((k1,k2),sim): str(k1) + '\t' + str(k2) + '\t' + str(sim) 
                  ).saveAsTextFile(path + "/similarities-200")     


