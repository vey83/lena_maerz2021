#Daten simulieren Kantone!!!
for (b in 1:3) {

results_kantone$gebietAusgezaehlt[b] <- TRUE
results_kantone$jaStimmenInProzent[b] <- runif(1,0,100)

}