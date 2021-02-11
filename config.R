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
library(DatawRappr)

cat("Benoetigte Bibliotheken geladen\n")

#Link zu JSON-Daten / Daten einlesen
link_json <- "https://app-prod-static-voteinfo.s3.eu-central-1.amazonaws.com/v1/ogd/sd-t-17-02-20210307-eidgAbstimmung.json" 
#link_json <- "https://app-prod-static-voteinfo.s3.eu-central-1.amazonaws.com/v1/ogd/sd-t-17-02-20201129-eidgAbstimmung.json" 
json_data <- fromJSON(link_json, flatten = TRUE)

link_json_kantone <- "https://app-prod-static-voteinfo.s3.eu-central-1.amazonaws.com/v1/ogd/sd-t-17-02-20210307-kantAbstimmung.json"
#link_json_kantone <- "https://app-prod-static-voteinfo.s3.eu-central-1.amazonaws.com/v1/ogd/sd-t-17-02-20201129-kantAbstimmung.json"
json_data_kantone <- fromJSON(link_json_kantone, flatten = TRUE)

cat("Aktuelle Abstimmungsdaten geladen\n")

#Kurznamen Vorlagen (Verwendet im File mit den Textbausteinen)
vorlagen_short <- c("Verhuellungsverbot","E-ID-Gesetz","Indonesien")

###Kurznamen und Nummern kantonale Vorlagen
kantonal_short <- c("ZH_Sozialdetektive","GE_Coronavirus")

#Nummer in JSON 
kantonal_number <- c(1,6) #3,13,13

#Falls mehrere Vorlagen innerhalb eines Kantons, Vorlage auswählen
kantonal_add <- c(2,1) #  1,1,1

###Vorhandene Daten laden Gripen / Masseneinwanderungsinitiative
daten_minarett_bfs <- read_excel("Data/daten_minarett_bfs.xls", 
                               skip = 10)

cat("Daten zu historischen Abstimmungen geladen\n")

#Metadaten Gemeinden und Kantone
meta_gmd_kt <- read_csv("Data/MASTERFILE_GDE_NEW.csv")

cat("Metadaten zu Gemeinden und Kantonen geladen\n")

#Datawrapper-Codes
datawrapper_codes <- read_excel("Data/Datawrapper_Codes.xlsx")

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


