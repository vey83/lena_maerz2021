#Working Directory definieren
setwd("C:/Users/simon/OneDrive/LENA_Project/lena_maerz2021")

###Config: Bibliotheken laden, Pfade/Links definieren, bereits vorhandene Daten laden
source("config.R",encoding = "UTF-8")


###Funktionen laden
source("functions_readin.R", encoding = "UTF-8")
source("functions_storyfinder.R", encoding = "UTF-8")
source("functions_storybuilder.R", encoding = "UTF-8")
source("functions_output.R", encoding = "UTF-8")

#Anzahl, Name und Nummer der Vorlagen von JSON einlesen
vorlagen <- get_vorlagen(json_data,"de")

###LENA alle 5 Sekunden laufen lassen
#repeat{

#Sys.sleep(5)

time_start <- Sys.time()

###Nationale Abstimmungen###
source("nationale_abstimmungen.R", encoding="UTF-8")

###Kantonale Abstimmungen###
source("kantonale_abstimmungen.R", encoding="UTF-8")

#Wie lange hat LENA gebraucht
time_end <- Sys.time()
cat(time_end-time_start)

#Make Commit
git2r::config(user.name = "awp-finanznachrichten",user.email = "sw@awp.ch")
gitadd()
gitcommit()
gitpush()

#Tabellen aktualisieren
source("top_flop.R", encoding = "UTF-8")


#Make Commit
git2r::config(user.name = "awp-finanznachrichten",user.email = "sw@awp.ch")
gitadd()
gitcommit()
gitpush()

cat("Daten erfolgreich auf Github hochgeladen\n")

#}

