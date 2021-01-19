#Bibliotheken laden
library(dplyr)
library(tidyr)
library(purrr)
library(readr)
library(ggplot2)
library(stringr)
library(stringi)
library(xml2)
library(rjson)
library(jsonlite)
library(readxl)
library(git2r)

print("Benoetigte Bibliotheken geladen\n")


gitcommit <- function(msg = "commit from Rstudio", dir = getwd()){
  cmd = sprintf("git commit -m\"%s\"",msg)
  system(cmd)
}

gitstatus <- function(dir = getwd()){
  cmd_list <- list(
    cmd1 = tolower(substr(dir,1,2)),
    cmd2 = paste("cd",dir),
    cmd3 = "git status"
  )
  cmd <- paste(unlist(cmd_list),collapse = " & ")
  shell(cmd)
}

gitadd <- function(dir = getwd()){
  cmd_list <- list(
    cmd1 = tolower(substr(dir,1,2)),
    cmd2 = paste("cd",dir),
    cmd3 = "git add --all"
  )
  cmd <- paste(unlist(cmd_list),collapse = " & ")
  shell(cmd)
}

gitpush <- function(dir = getwd()){
  cmd_list <- list(
    cmd1 = tolower(substr(dir,1,2)),
    cmd2 = paste("cd",dir),
    cmd3 = "git push"
  )
  cmd <- paste(unlist(cmd_list),collapse = " & ")
  shell(cmd)
}


#Link zu JSON-Daten / Daten einlesen
link_json <- "https://app-prod-static-voteinfo.s3.eu-central-1.amazonaws.com/v1/ogd/sd-t-17-02-20201129-eidgAbstimmung.json" 
json_data <- fromJSON(link_json, flatten = TRUE)

link_json_kantone <- "https://app-prod-static-voteinfo.s3.eu-central-1.amazonaws.com/v1/ogd/sd-t-17-02-20201129-kantAbstimmung.json"
json_data_kantone <- fromJSON(link_json_kantone, flatten = TRUE)

print("Aktuelle Abstimmungsdaten geladen\n")

#Kurznamen Vorlagen (Verwendet im File mit den Textbausteinen)
vorlagen_short <- c("Konzernverantwortung","Kriegsgeschaefte")

###Kurznamen und Nummern kantonale Vorlagen
kantonal_short <- c("FR_Pensionskasse","GE_Handicap","GE_Avusy")

#Nummer in JSON 
kantonal_number <- c(4,11,11) #3,13,13

#Falls mehrere Vorlagen innerhalb eines Kantons, Vorlage auswählen
kantonal_add <- c(1,1,2) #  1,1,1

###Vorhandene Daten laden Gripen / Masseneinwanderungsinitiative
daten_kriegsmaterial_bfs <- read_excel("Data/daten_kriegsmaterial_bfs.xlsx", 
                               skip = 10)

cat("Daten zu historischen Abstimmungen geladen\n")

#Metadaten Gemeinden und Kantone
meta_gmd_kt <- read_csv("Data/MASTERFILE_GDE_NEW.csv")

#library(readxl)
#italienisch <- read_excel("C:/Users/simon/OneDrive/Desktop/italienisch.xlsx")
#kantone_it <- read_excel("C:/Users/simon/OneDrive/Desktop/Kantone_it.xlsx")

#meta_gmd_kt <- merge(meta_gmd_kt,italienisch,all.x = TRUE)
#meta_gmd_kt <- merge(meta_gmd_kt,kantone_it,all.x = TRUE)

#meta_gmd_kt$Gmeinde_KT_i <- NA

#for (i in 1:nrow(meta_gmd_kt)) {
  
#if (is.na(meta_gmd_kt$Gemeinde_i[i]) == TRUE) {

#meta_gmd_kt$Gemeinde_i[i] <- meta_gmd_kt$Gemeinde_d[i]
      
#}

#meta_gmd_kt$Gmeinde_KT_i[i] <- paste0(meta_gmd_kt$Gemeinde_i[i]," ",meta_gmd_kt$Kanton_Short[i])    
    
#}

#write.csv(meta_gmd_kt,"MASTERFILE_GDE_NEW.csv", row.names = FALSE)

cat("Metadaten zu Gemeinden und Kantonen geladen\n")


