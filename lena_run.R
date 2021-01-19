View(results_kantone)

#Zeit stoppen
time_start <- Sys.time()

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

###Natioanle Abstimmungen###

for (i in 1:length(vorlagen_short)) {

cat(paste0("\nErmittle Daten für folgende Vorlage: ",vorlagen$text[i],"\n"))
  
###Resultate aus JSON auslesen 
results <- get_results(json_data,i)

#Emergency adapt
#results$gebietAusgezaehlt[155] <- TRUE
#results$gebietAusgezaehlt[911] <- TRUE
#results$gebietAusgezaehlt[912] <- TRUE
#results$gebietAusgezaehlt[913] <- TRUE

#Daten anpassen Gemeinden
results <- treat_gemeinden(results)
results <- format_data_g(results)

#Kantonsdaten hinzufügen
results_kantone <- get_results(json_data,i,"cantonal")

Ja_Stimmen_Kanton <- results_kantone %>%
  select(Kantons_Nr,jaStimmenInProzent) %>%
  rename(Ja_Stimmen_In_Prozent_Kanton = jaStimmenInProzent) %>%
  mutate(Highest_Yes_Kant = FALSE,
         Highest_No_Kant = FALSE)

results <- merge(results,Ja_Stimmen_Kanton)


#Wie viele Gemeinden sind ausgezählt
cat(paste0(sum(results$Gebiet_Ausgezaehlt)," Gemeinden sind ausgezählt.\n"))

#Neue Variablen
results <- results %>%
  mutate(Ja_Nein = NA,
         Oui_Non = NA,
         Unentschieden = NA,
         Einstimmig_Ja = NA,
         Einstimmig_Nein = NA,
         kleine_Gemeinde = NA,
         Storyboard = NA,
         Text_d = "Die Resultate von dieser Gemeinde sind noch nicht bekannt.",
         Text_f = "Les résultats ne sont pas encore connus dans cette commune.",
         Text_i = "I resultati di questa comune non sono ancora noti.")

hist_check <- FALSE

#Ausgezählte Gemeinden auswählen
results_notavailable <- results[results$Gebiet_Ausgezaehlt == FALSE,]
results <- results[results$Gebiet_Ausgezaehlt == TRUE,]

#Sind schon Daten vorhanden?
if (nrow(results) > 0) {

#Daten anpassen
results <- augment_raw_data(results)

#Intros generieren
results <- normal_intro(results)

#LENA-Classics (falls alle Gemeinden ausgezählt):
if (nrow(results_notavailable) == 0) {

results <- lena_classics(results)

}  

#Historischer Vergleich (falls vorhanden)

#Check Vorlagen-ID

if (vorlagen$id[i] == "6370") { #6320

hist_check <- TRUE 
data_hist <- format_data_hist(daten_kriegsmaterial_bfs)
results <- merge(results,data_hist,all.x = TRUE)
results <- hist_storyfinder(results)

}


#Vergleich innerhalb des Kantons (falls alle Daten vom Kanton vorhanden)

#Check Vorlagen-ID
if (vorlagen$id[i] == "6360") {
  
#Falls mindestens ein Kanton ausgezählt -> Stories für die Kantone finden
  
if (sum(results_kantone$gebietAusgezaehlt) > 0) {
  
results <- kanton_storyfinder(results)

}

}


###Storybuilder

#Textvorlagen laden
Textbausteine <- as.data.frame(read_excel("Data/Textbausteine_LENA_November2020.xlsx", 
                                               sheet = vorlagen_short[i]))
cat("Textvorlagen geladen\n\n")

#Texte einfügen
results <- build_texts(results)

#Variablen ersetzen 
results <- replace_variables(results)

###Texte anpassen und optimieren
results <- excuse_my_french(results)

#Print out texts
#cat(paste0(results$Gemeinde_d,"\n",results$Text_d,"\n\n",results$Text_f,collapse="\n\n"))

}
###Ausgezählte und nicht ausgezählte Gemeinden wieder zusammenführen -> Immer gleiches Format für Datawrapper
if (nrow(results_notavailable) > 0) {

results_notavailable$Ja_Stimmen_In_Prozent <- 50

if (hist_check == TRUE) {
results_notavailable$Hist_Ja_Stimmen_In_Prozent <- NA
results_notavailable$Hist_Ja_Stimmen_Absolut <- NA
results_notavailable$Hist_Nein_Stimmen_In_Prozent <- NA
results_notavailable$Hist_Nein_Stimmen_Absolut <- NA
}

results <- rbind(results,results_notavailable) %>%
  arrange(Gemeinde_Nr)

}

#Texte speichern
#library(xlsx)
#write.xlsx(results,paste0(vorlagen_short[i],"_texte.xlsx"),row.names = FALSE)

###Output generieren für Datawrapper

#Output Abstimmungen Gemeinde

output_dw <- get_output_gemeinden(results)

#Output speichern
write.csv(output_dw,paste0("Output/",vorlagen_short[i],"_dw.csv"), na = "", row.names = FALSE, fileEncoding = "UTF-8")

#Output Abstimmungen Kantone
output_dw_kantone <- get_output_kantone(results)

write.csv(output_dw_kantone,paste0("Output/",vorlagen_short[i],"_dw_kantone.csv"), na = "", row.names = FALSE, fileEncoding = "UTF-8")

cat(paste0("\nGenerated output for Vorlage ",vorlagen_short[i],"\n"))
}


###Kantonale Abstimmungen###

for (k in 1:length(kantonal_short) ) {
  
  cat(paste0("\nErmittle Daten für folgende Vorlage: ",kantonal_short[k],"\n"))
  
  results <- get_results_kantonal(json_data_kantone,
                                  kantonal_number[k],
                                  kantonal_add[k])
  
  
  #Daten anpassen Gemeinden
  results <- treat_gemeinden(results)
  results <- format_data_g(results)

  #Kantonsergebnis hinzufügen
  Ja_Stimmen_Kanton <- get_results_kantonal(json_data_kantone,
                                            kantonal_number[k],
                                            kantonal_add[k],
                                            "kantonal")
  
  results$Ja_Stimmen_In_Prozent_Kanton <- Ja_Stimmen_Kanton

  #Wie viele Gemeinden sind ausgezählt?
  cat(paste0(sum(results$Gebiet_Ausgezaehlt)," Gemeinden sind ausgezählt.\n"))
  
  #Neue Variablen
  results <- results %>%
  mutate(Ja_Nein = NA,
  Oui_Non = NA,
  Nein_Stimmen_In_Prozent = NA,
  Unentschieden = NA,
  Einstimmig_Ja = NA,
  Einstimmig_Nein = NA,
  kleine_Gemeinde = NA,
  Highest_Yes_Kant = FALSE,
  Highest_No_Kant = FALSE,
  Storyboard = NA,
  Text_d = "Die Resultate von dieser Gemeinde sind noch nicht bekannt.",
  Text_f = "Les résultats ne sont pas encore connus dans cette commune.")
  
  hist_check <- FALSE
  
  #Ausgezählte Gemeinden auswählen
  results_notavailable <- results[results$Gebiet_Ausgezaehlt == FALSE,]
  results <- results[results$Gebiet_Ausgezaehlt == TRUE,]
  
  #Sind schon Daten vorhanden?
  if (nrow(results) > 0) {
  
  #Daten anpassen
  results <- augment_raw_data(results)
  
  #Intros generieren
  results <- normal_intro(results)
 

  
  #Vergleich innerhalb des Kantons (falls Daten vom Kanton vorhanden) -> Ändern von FALSE auf TRUE
  
  #if (json_data_kantone$kantone$vorlagen[[kantonal_number[k]]]$vorlageBeendet[[kantonal_add[k]]] == FALSE) {
    
    results <- kanton_storyfinder_kantonal(results)
    
  #}
  
  #Textvorlagen laden
  Textbausteine <- as.data.frame(read_excel("Data/Textbausteine_LENA_November2020.xlsx", 
                                            sheet = kantonal_short[k]))
  cat("Textvorlagen geladen\n\n")
  
  #Texte einfügen
  results <- build_texts(results)
  
  #Variablen ersetzen 
  results <- replace_variables(results)
  
  ###Texte anpassen und optimieren
  results <- excuse_my_french(results)
  
  #Print out texts
  #cat(paste0(results$Gemeinde_d,"\n",results$Text_d,"\n\n",results$Text_f,collapse="\n\n"))
  
  }
  ###Ausgezählte und nicht ausgezählte Gemeinden wieder zusammenführen -> Immer gleiches Format für Datawrapper
  if (nrow(results_notavailable) > 0) {
    
    results_notavailable$Ja_Stimmen_In_Prozent <- 50
    
    results <- rbind(results,results_notavailable) %>%
      arrange(Gemeinde_Nr)
    
  }
  
  #Texte speichern
  #library(xlsx)
  #write.xlsx(results,paste0(kantonal_short[k],"_texte.xlsx"))
  
  ###Output generieren für Datawrapper
  output_dw <- get_output_gemeinden(results)
  
  write.csv(output_dw,paste0("Output/",kantonal_short[k],"_dw.csv"), na = "", row.names = FALSE, fileEncoding = "UTF-8")
  
  cat(paste0("\nGenerated output for Vorlage ",kantonal_short[k],"\n"))
  
}

#Wie lange hat LENA gebraucht
time_end <- Sys.time()
print(time_end-time_start)

#Make Commit
git2r::config(user.name = "awp-finanznachrichten",user.email = "sw@awp.ch")
gitadd()
gitcommit()
gitpush()
