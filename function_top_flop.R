make_table <- function(voile_raw,
                       type = "yes",
                       language = "f") {
      
  if (type == "yes") {
    
    if (language == "f") {
                   
      table_content <- voile_raw %>%
              arrange(desc(Ja_Stimmen_In_Prozent)) %>%
              slice(1:50) %>%
              select(6,3) %>%
              rename(Commune = Gemeinde_KT_f,
              "Pourcentage de oui" = Ja_Stimmen_In_Prozent)
      
    } else if (language == "d") {
      
      
      table_content <- voile_raw %>%
        arrange(desc(Ja_Stimmen_In_Prozent)) %>%
        slice(1:50) %>%
        select(5,3) %>%
        rename(Gemeinde = Gemeinde_KT_d,
               "Ja-Anteil" = Ja_Stimmen_In_Prozent)

  } else if (language == "i") {
    
    table_content <- voile_raw %>%
      arrange(desc(Ja_Stimmen_In_Prozent)) %>%
      slice(1:50) %>%
      select(7,3) %>%
      rename(Municipio = Gemeinde_KT_i,
             "Per cento sì" = Ja_Stimmen_In_Prozent) 
    
  }
  }    

  
  if (type == "no") {
    
    if (language == "f") {
      
      table_content <- voile_raw %>%
        arrange(desc(Nein_Stimmen_In_Prozent)) %>%
        slice(1:50) %>%
        select(6,3) %>%
        rename(Commune = Gemeinde_KT_f,
               "Pourcentage de non" = Nein_Stimmen_In_Prozent)
      
    } else if (language == "d") {
      
      
      table_content <- voile_raw %>%
        arrange(desc(Nein_Stimmen_In_Prozent)) %>%
        slice(1:50) %>%
        select(5,3) %>%
        rename(Gemeinde = Gemeinde_KT_d,
               "Nein-Anteil" = Nein_Stimmen_In_Prozent)
      
    } else if (language == "i") {
      
      table_content <- voile_raw %>%
        arrange(desc(Nein_Stimmen_In_Prozent)) %>%
        slice(1:50) %>%
        select(7,3) %>%
        rename(Municipio = Gemeinde_KT_i,
               "Per cento no" = Nein_Stimmen_In_Prozent) 
      
    }
  }    
      
      return(table_content)
      
}