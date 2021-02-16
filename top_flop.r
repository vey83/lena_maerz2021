#import
#library(tidyverse)

##VOILE

#VOILE_TOP
voile_raw <- read_csv("https://raw.githubusercontent.com/awp-finanznachrichten/lena_maerz2021/master/Output/Verhuellungsverbot_dw.csv")

voile_top_fr <- voile_raw %>%
  arrange(desc(Ja_Stimmen_In_Prozent)) %>%
  slice(1:50) %>%
  select(6,3) %>%
  rename(Commune = Gemeinde_KT_f,
         "Pourcentage de oui" = Ja_Stimmen_In_Prozent)

write.csv(voile_top_fr,"Tableaux/voile_top_fr.csv")


voile_top_de <- voile_raw %>%
  arrange(desc(Ja_Stimmen_In_Prozent)) %>%
  slice(1:50) %>%
  select(5,3) %>%
  rename(Gemeinde = Gemeinde_KT_d,
         "Ja-Anteil" = Ja_Stimmen_In_Prozent)

write.csv(voile_top_de,"Tableaux/voile_top_de.csv")


voile_top_it <- voile_raw %>%
  arrange(desc(Ja_Stimmen_In_Prozent)) %>%
  slice(1:50) %>%
  select(7,3) %>%
  rename(Municipio = Gemeinde_KT_i,
         "Per cento sì" = Ja_Stimmen_In_Prozent)

write.csv(voile_top_it,"Tableaux/voile_top_it.csv")


#VOILE_FLOP

voile_flop_fr <- voile_raw %>%
  arrange(desc(Nein_Stimmen_In_Prozent)) %>%
  slice(1:50) %>%
  select(6,4) %>%
  rename(Commune = Gemeinde_KT_f,
         "Pourcentage de non" = Nein_Stimmen_In_Prozent)

write.csv(voile_flop_fr,"Tableaux/voile_flop_fr.csv")


voile_flop_de <- voile_raw %>%
  arrange(desc(Nein_Stimmen_In_Prozent)) %>%
  slice(1:50) %>%
  select(5,4) %>%
  rename(Gemeinde = Gemeinde_KT_d,
         "Nein-Anteil" = Nein_Stimmen_In_Prozent)

write.csv(voile_flop_de,"Tableaux/voile_flop_de.csv")


voile_flop_it <- voile_raw %>%
  arrange(desc(Nein_Stimmen_In_Prozent)) %>%
  slice(1:50) %>%
  select(7,4) %>%
  rename(Municipio = Gemeinde_KT_i,
         "Per cento no" = Nein_Stimmen_In_Prozent)

write.csv(voile_flop_it,"Tableaux/voile_flop_it.csv")
#Hasle LU LU



##E-ID
eid_raw <-  read_csv("https://raw.githubusercontent.com/awp-finanznachrichten/lena_maerz2021/master/Output/E-ID-Gesetz_dw.csv")

#E-ID_TOP
eid_top_fr <- eid_raw %>%
  arrange(desc(Ja_Stimmen_In_Prozent)) %>%
  slice(1:50) %>%
  select(6,3) %>%
  rename(Commune = Gemeinde_KT_f,
         "Pourcentage de oui" = Ja_Stimmen_In_Prozent)

write.csv(eid_top_fr,"Tableaux/eid_top_fr.csv")


eid_top_de <- eid_raw %>%
  arrange(desc(Ja_Stimmen_In_Prozent)) %>%
  slice(1:50) %>%
  select(5,3) %>%
  rename(Gemeinde = Gemeinde_KT_d,
         "Ja-Anteil" = Ja_Stimmen_In_Prozent)

write.csv(eid_top_de,"Tableaux/eid_top_de.csv")


eid_top_it <- eid_raw %>%
  arrange(desc(Ja_Stimmen_In_Prozent)) %>%
  slice(1:50) %>%
  select(7,3) %>%
  rename(Municipio = Gemeinde_KT_i,
         "Per cento sì" = Ja_Stimmen_In_Prozent)

write.csv(eid_top_it,"Tableaux/eid_top_it.csv")


#E-ID_FLOP

eid_flop_fr <- eid_raw %>%
  arrange(desc(Nein_Stimmen_In_Prozent)) %>%
  slice(1:50) %>%
  select(6,4) %>%
  rename(Commune = Gemeinde_KT_f,
         "Pourcentage de non" = Nein_Stimmen_In_Prozent)

write.csv(eid_flop_fr,"Tableaux/eid_flop_fr.csv")


eid_flop_de <- eid_raw %>%
  arrange(desc(Nein_Stimmen_In_Prozent)) %>%
  slice(1:50) %>%
  select(5,4) %>%
  rename(Gemeinde = Gemeinde_KT_d,
         "Nein-Anteil" = Nein_Stimmen_In_Prozent)

write.csv(eid_flop_de,"Tableaux/eid_flop_de.csv")


eid_flop_it <- eid_raw %>%
  arrange(desc(Nein_Stimmen_In_Prozent)) %>%
  slice(1:50) %>%
  select(7,4) %>%
  rename(Municipio = Gemeinde_KT_i,
         "Per cento no" = Nein_Stimmen_In_Prozent)

write.csv(eid_flop_it,"Tableaux/eid_flop_it.csv")


##LIBRE-ECHANGE INDONESIE

#A adapter avant la votation!
indo_raw <- read_csv("https://raw.githubusercontent.com/awp-finanznachrichten/lena_maerz2021/master/Output/Indonesien_dw.csv")

#INDO_TOP
indo_top_fr <- indo_raw %>%
  arrange(desc(Ja_Stimmen_In_Prozent)) %>%
  slice(1:50) %>%
  select(6,3) %>%
  rename(Commune = Gemeinde_KT_f,
         "Pourcentage de oui" = Ja_Stimmen_In_Prozent)

write.csv(indo_top_fr,"Tableaux/indo_top_fr.csv")


indo_top_de <- indo_raw %>%
  arrange(desc(Ja_Stimmen_In_Prozent)) %>%
  slice(1:50) %>%
  select(5,3) %>%
  rename(Gemeinde = Gemeinde_KT_d,
         "Ja-Anteil" = Ja_Stimmen_In_Prozent)

write.csv(indo_top_de,"Tableaux/indo_top_de.csv")


indo_top_it <- indo_raw %>%
  arrange(desc(Ja_Stimmen_In_Prozent)) %>%
  slice(1:50) %>%
  select(7,3) %>%
  rename(Municipio = Gemeinde_KT_i,
         "Per cento sì" = Ja_Stimmen_In_Prozent)

write.csv(indo_top_it,"Tableaux/indo_top_it.csv")


#INDO_FLOP

indo_flop_fr <- indo_raw %>%
  arrange(desc(Nein_Stimmen_In_Prozent)) %>%
  slice(1:50) %>%
  select(6,4) %>%
  rename(Commune = Gemeinde_KT_f,
         "Pourcentage de non" = Nein_Stimmen_In_Prozent)

write.csv(indo_flop_fr,"Tableaux/indo_flop_fr.csv")


indo_flop_de <- indo_raw %>%
  arrange(desc(Nein_Stimmen_In_Prozent)) %>%
  slice(1:50) %>%
  select(5,4) %>%
  rename(Gemeinde = Gemeinde_KT_d,
         "Nein-Anteil" = Nein_Stimmen_In_Prozent)

write.csv(indo_flop_de,"Tableaux/indo_flop_de.csv")


indo_flop_it <- indo_raw %>%
  arrange(desc(Nein_Stimmen_In_Prozent)) %>%
  slice(1:50) %>%
  select(7,4) %>%
  rename(Municipio = Gemeinde_KT_i,
         "Per cento no" = Nein_Stimmen_In_Prozent)

write.csv(indo_flop_it,"Tableaux/indo_flop_it.csv")
