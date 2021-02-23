voile21_raw <- read_csv("https://raw.githubusercontent.com/awp-finanznachrichten/lena_maerz2021/master/Output/Verhuellungsverbot_dw.csv")

mina09_raw <-  read_excel("Data/daten_minarett_bfs-2.xls")

#Wrangling
mina09 <- mina09_raw %>%
  select(3,11)

#Runden
mina09$`Ja in %` <- round(mina09$`Ja in %`,1)

#en français
voile21_fr <- voile21_raw %>%
  select(1,3,4,6) %>%
  left_join(mina09, by = c("Gemeinde_Nr" = "Gemeinde-Nr.")) %>%
  mutate(ecart = Ja_Stimmen_In_Prozent - `Ja in %`)

augment_fr <- voile21_fr %>%
  arrange(desc(ecart)) %>%
  select(4,2,5,6) %>%
  rename(Commune = Gemeinde_KT_f,
         'Oui à l\'interdiction de se dissimuler le visage dans l\'espace public (2021)' = Ja_Stimmen_In_Prozent,
         'Oui à l\'interdiction de construire des minarets (2009)' = 'Ja in %',
         'Ecart (en points de pourcentage)' = ecart) %>%
  slice(1:50)

diminu_fr <- voile21_fr %>%
  arrange(ecart) %>%
  select(4,2,5,6) %>%
  rename(Commune = Gemeinde_KT_f,
         'Oui à l\'interdiction de se dissimuler le visage dans l\'espace public (2021)' = Ja_Stimmen_In_Prozent,
         'Oui à l\'interdiction de construire des minarets (2009)' = 'Ja in %',
         'Ecart (en points de pourcentage)' = ecart) %>%
  slice(1:50)

write.csv(augment_fr,"Tableaux/augment_fr.csv", fileEncoding = "UTF-8")
write.csv(diminu_fr, "Tableaux/diminu_fr.csv", fileEncoding = "UTF-8")

#en allemand
voile21_de <- voile21_raw %>%
  select(1,3,4,5) %>%
  left_join(mina09, by = c("Gemeinde_Nr" = "Gemeinde-Nr.")) %>%
  mutate(ecart = Ja_Stimmen_In_Prozent - `Ja in %`)

augment_de <- voile21_de %>%
  arrange(desc(ecart)) %>%
  select(4,2,5,6) %>%
  rename(Gemeinde = Gemeinde_KT_d,
         'Ja zum Verhüllungsverbot (2021)' = Ja_Stimmen_In_Prozent,
         'Ja zum Minarettverbot (2009)' = 'Ja in %',
         'Veränderung (in Prozentpunkten)' = ecart) %>%
  slice(1:50)

diminu_de <- voile21_de %>%
  arrange(ecart) %>%
  select(4,2,5,6) %>%
  rename(Gemeinde = Gemeinde_KT_d,
         'Ja zum Verhüllungsverbot (2021)' = Ja_Stimmen_In_Prozent,
         'Ja zum Minarettverbot (2009)' = 'Ja in %',
         'Veränderung (in Prozentpunkten)' = ecart) %>%
  slice(1:50)

write.csv(augment_de,"Tableaux/augment_de.csv", fileEncoding = "UTF-8")
write.csv(diminu_de, "Tableaux/diminu_de.csv", fileEncoding = "UTF-8")

#en italien
voile21_it <- voile21_raw %>%
  select(1,3,4,7) %>%
  left_join(mina09, by = c("Gemeinde_Nr" = "Gemeinde-Nr.")) %>%
  mutate(ecart = Ja_Stimmen_In_Prozent - `Ja in %`)

augment_it <- voile21_it %>%
  arrange(desc(ecart)) %>%
  select(4,2,5,6) %>%
  rename(Comune = Gemeinde_KT_i,
         'Sì all\'iniziativa anti-burqa (2021)' = Ja_Stimmen_In_Prozent,
         'Sì al divieto di costruzione di minareti (2009)' = 'Ja in %', 
         'Scarto (in punti percentuali)' = ecart) %>% 
  slice(1:50)

diminu_it <- voile21_it %>%
  arrange(ecart) %>%
  select(4,2,5,6) %>%
  rename(Comune = Gemeinde_KT_i,
         'Sì all\'iniziativa anti-burqa (2021)' = Ja_Stimmen_In_Prozent,
         'Sì al divieto di costruzione di minareti (2009)' = 'Ja in %', 
         'Scarto (in punti percentuali)' = ecart) %>% 
  slice(1:50)

write.csv(augment_it,"Tableaux/augment_it.csv", fileEncoding = "UTF-8")
write.csv(diminu_it, "Tableaux/diminu_it.csv", fileEncoding = "UTF-8")
