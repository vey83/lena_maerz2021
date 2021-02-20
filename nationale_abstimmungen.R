for (i in 1:length(vorlagen_short)) {
  
  cat(paste0("\nErmittle Daten für folgende Vorlage: ",vorlagen$text[i],"\n"))
  
  
  ###Nationale Resultate aus JSON auslesen
  results_national <- get_results(json_data,i,level="national")

  ###Resultate aus JSON auslesen für Gemeinden
  results <- get_results(json_data,i)
  
#Simulation Gemeinden
source("data_simulation_gemeinden.R")
  

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
  
  #Simulation Kantone
  source("data_simulation_kantone.R")
  
  json_data$schweiz$vorlagen$kantone
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
    
    if (vorlagen$id[i] == "6380") { 
      
      hist_check <- TRUE 
      data_hist <- format_data_hist(daten_minarett_bfs)
      results <- merge(results,data_hist,all.x = TRUE)
      results <- hist_storyfinder(results)
      
    }
    
    
    #Vergleich innerhalb des Kantons (falls alle Daten vom Kanton vorhanden)
    
    #Check Vorlagen-ID
    if (vorlagen$id[i] == "6390" || vorlagen$id[i] == "6400") {
      
      #Falls mindestens ein Kanton ausgezählt -> Stories für die Kantone finden
      
      if (length(unique(results_notavailable$Kantons_Nr)) < 26) {
        
        results <- kanton_storyfinder(results)
        
      }
      
    }
    
    
    ###Storybuilder
    
    #Textvorlagen laden
    Textbausteine <- as.data.frame(read_excel("Data/Textbausteine_LENA_Maerz2021.xlsx", 
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
    
    results_notavailable$Ja_Stimmen_In_Prozent <- 0
    results_notavailable$Nein_Stimmen_In_Prozent <- 0
    results_notavailable$Gemeinde_color <- 50
    
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
  
  
  ###Output generieren für Datawrapper Tessin
  
  #Output Abstimmungen Gemeinde
  output_dw_ticino <- results[results$Kanton_Short == "TI",]
  output_dw_ticino <- get_output_gemeinden(output_dw_ticino)

  #Output speichern
  write.csv(output_dw_ticino,paste0("Output/",vorlagen_short[i],"_dw_ticino.csv"), na = "", row.names = FALSE, fileEncoding = "UTF-8")
  
  #Output Abstimmungen Kantone
  output_dw_kantone <- get_output_kantone(results)
  
  write.csv(output_dw_kantone,paste0("Output/",vorlagen_short[i],"_dw_kantone.csv"), na = "", row.names = FALSE, fileEncoding = "UTF-8")
  
  cat(paste0("\nGenerated output for Vorlage ",vorlagen_short[i],"\n"))
  
  #Datawrapper-Karten aktualisieren
  undertitel_de <- "Es sind noch keine Gemeinden ausgezählt."
  undertitel_fr <- "Aucun résultat n'est encore connu."
  undertitel_it <- "Nessun risultato è ancora noto."
  
  if (sum(results$Gebiet_Ausgezaehlt) > 0 ) {
    
    undertitel_de <- paste0("Es sind <b>",sum(results$Gebiet_Ausgezaehlt),"</b> von <b>",nrow(results),
                            "</b> Gemeinden ausgezählt. Stand: <b>",
                            round(results_national$jaStimmenInProzent,1)," %</b> Ja, <b>",
                            round(100-results_national$jaStimmenInProzent,1)," %</b> Nein")
    
    undertitel_fr <- paste0("Le résultats de <b>",sum(results$Gebiet_Ausgezaehlt),"</b> des <b>",nrow(results),
                            "</b> communes sont connus. Etat: <b>",
                            round(results_national$jaStimmenInProzent,1)," %</b> oui, <b>",
                            round(100-results_national$jaStimmenInProzent,1)," %</b> non")
    
    undertitel_it <- paste0("I risultati di <b>",sum(results$Gebiet_Ausgezaehlt),"</b> dei <b>",nrow(results),
                            "</b> communi sono noti. Stato: <b>",
                            round(results_national$jaStimmenInProzent,1)," %</b> sì, <b>",
                            round(100-results_national$jaStimmenInProzent,1)," %</b> no")
    
    
    #Karten Gemeinden
    dw_edit_chart(datawrapper_codes[i,2],intro=undertitel_de,annotate=paste0("Letzte Aktualisierung: ",format(Sys.time(),"%d.%m.%Y %H:%M Uhr")))
    dw_publish_chart(datawrapper_codes[i,2])
    
    dw_edit_chart(datawrapper_codes[i,4],intro=undertitel_fr,annotate=paste0("dernière mise à jour: ",format(Sys.time(),"%d.%m.%Y %H:%M Uhr")))
    dw_publish_chart(datawrapper_codes[i,4])
    
    dw_edit_chart(datawrapper_codes[i,6],intro=undertitel_it,annotate=paste0("Ultimo aggiornamento: ",format(Sys.time(),"%d.%m.%Y %H:%M Uhr")))
    dw_publish_chart(datawrapper_codes[i,6])
    
    #Karten Kantone
    dw_edit_chart(datawrapper_codes[i,3],intro=undertitel_de,annotate=paste0("Letzte Aktualisierung: ",format(Sys.time(),"%d.%m.%Y %H:%M Uhr")))
    dw_publish_chart(datawrapper_codes[i,3])
    
    dw_edit_chart(datawrapper_codes[i,5],intro=undertitel_fr,annotate=paste0("dernière mise à jour: ",format(Sys.time(),"%d.%m.%Y %H:%M Uhr")))
    dw_publish_chart(datawrapper_codes[i,5])
    
    dw_edit_chart(datawrapper_codes[i,7],intro=undertitel_it,annotate=paste0("Ultimo aggiornamento: ",format(Sys.time(),"%d.%m.%Y %H:%M Uhr")))
    dw_publish_chart(datawrapper_codes[i,7])
    
  }
  
  

  
}
