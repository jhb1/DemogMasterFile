# TITLE ##############################################################
#
# population_master.r
#
# I am asking our Demographic team for the creation and maintenance of a central population master file, which will be stored and accessible to all teams in a single location. This master file will include all the raw disaggregated information by age and gender that teams need to create the respective population of reference for your indicators.
#
# title_end ################################################################

rm(list=ls())


# library(RColorBrewer)
# library(scales)
# library(stringr)
# library(grid) # for function arrow() and waffle
# library(gridExtra)
# library(gtable)
# library(knitr)
library(tidyverse)
# library(waffle)
# library(RColorBrewer)
# library(writexl)

# global -----------------------------------------------------------------------
`%out%` <- function(a,b) ! a %in% b


# input/output paths ----
path.basic <- str_c("C:/Users",
                    str_sub(getwd(), str_locate(getwd(), "C:/Users/")[2], str_locate(getwd(), "/D")[1]),
                    "Dropbox")
# path.basic.sp <- "C:/Users/jbeise/UNICEF/DA-Mortality and Demographics - Migration and Displacement - Documents/Migration and Displacement"
path.basic.sp <- "C:/Users/jbeise/OneDrive - UNICEF (1)/Migration and Displacement"


# sharepoint
input <-  file.path(path.basic.sp, "Data")
#  input <- file.path(path.basic, "Data")

output <- "C:/Users/jbeise/OneDrive - UNICEF (1)/Downloads_OneDrive/#Output"


# Notes to regions ----
# Development group: loctype.id == 5 
# SDG: loctype.id == 12
# Income groups: loctype.id == 13

# load(file.path(input,"UNPD/WPP2022/wpp_5y_age_group.rdata"))
load(file.path(input,"UNPD/WPP2022/wpp_age.Rdata"))
# load(file.path(input,"UNPD/WPP2022/wpp_age_group.rdata"))
# load(file.path(input,"UNPD/WPP2022/wpp_dem.rdata"))
# load(file.path(input,"UNPD/WPP2022/wpp_fertility.rdata"))
# load(file.path(input,"UNPD/WPP2022/wpp_location.rdata"))
# load(file.path(input,"UNPD/WPP2022/wpp_unicef.rdata"))

# ++++ Projects ++++ ------
wpp.pop.age.master <- wpp.age %>% 
  filter(area.id <= 900) %>%     # keeps only countries/areas and World
  select(area:year, iso3, age, pop.total.thsd =  pop.thsd) %>% 
  left_join(wpp.age.female %>% 
              select(area.id, year, age, pop.female.thsd = pop.thsd),
            by = c("area.id", "year", "age")) %>% 
  left_join(wpp.age.male %>% 
              select(area.id, year, age, pop.male.thsd = pop.thsd),
            by = c("area.id", "year", "age"))

save(wpp.pop.age.master, file = file.path(output, "wpp.pop.age.master.Rdata"))
write_csv(wpp.pop.age.master, file = file.path(output, "wpp.pop.age.master.csv"))
