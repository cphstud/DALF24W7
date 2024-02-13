library(mongolite)
library(dplyr)
library(jsonlite)
library(ggplot2)


#connections
conp <- mongo(
  url = "mongodb://localhost",
  db="wyscoutdutch",
  collection = "players"
)

conm <- mongo(
  url = "mongodb://localhost",
  db="wyscoutdutch",
  collection = "matches"
)

cong <- mongo(
  url = "mongodb://localhost",
  db="wyscoutdutch",
  collection = "games"
)

allMatches <- conm$find(
  query= '{}',
  fields= '{}'
)
allPlayers <- conp$find(
  query= '{}',
  fields= '{}'
)

allPlayers <- fromJSON(toJSON(allPlayers), flatten = T)
allMatches <- fromJSON(toJSON(allMatches), flatten = T)

# afleveringer - pr sæson og pr liga
table(allMatches$seasonId)
table(allMatches$competitionId)

# polske afleveringer pr sæson
# polske matchID'er
allPolishMatchesI <- conm$find(
  query= '{"competitionId":692,"seasonId":188088}',
  fields= '{}'
)
allPolishMatchesII <- conm$find(
  query= '{"competitionId":692,"seasonId":186215}',
  fields= '{}'
)
allDutchMatchesII <- conm$find(
  query= '{"competitionId":635,"seasonId":187502}',
  fields= '{}'
)
allDutchMatchesI <- conm$find(
  query= '{"competitionId":635,"seasonId":188125}',
  fields= '{}'
)

# polske kampe pr sæson vha array af matchId
#q1 <- paste0('{"matchId":{"$in":',idA, '}}')
pI <- allPolishMatchesI %>% select(`_id`) 
pI <- pI$`_id` %>% as.vector() 
pI <- toJSON(pI)

#db.games.find({matchId: {"$in": [5233343,5233332]}})
qpI <- paste0('{"type.primary":"pass","matchId": {"$in": ',pI,'}}')
allPolishGamesI <- cong$find(
  query= qpI,
  fields= '{}'
)

allPolishGamesI <- fromJSON(toJSON(allPolishGamesI),flatten = T)
saveRDS(allPolishGamesI,"allPolishGamesI.rds")

pII <- allPolishMatchesII %>% select(`_id`) 
pII <- pII$`_id` %>% as.vector() 
pII <- toJSON(pII)

qpII <- paste0('{"type.primary":"pass","matchId": {"$in": ',pII,'}}')
allPolishGamesII <- cong$find(
  query= qpII,
  fields= '{}'
)
dI <- allDutchMatchesI %>% select(`_id`) 
dI <- dI$`_id` %>% as.vector() 
dI <- toJSON(dI)

qd1 <- paste0('{"type.primary":"pass","matchId": {"$in": ',dI,'}}')
allDutchGamesII <- cong$find(
  query= qd1,
  fields= '{}'
)
allDutchGamesI <- fromJSON(toJSON(allDutchGamesII),flatten=T)








