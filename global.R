
library(data.table)
library(readxl)
library(readr)
library(ggplot2)
library(plotly)
library(DT)
library(shiny)
library(shinydashboard)
library(leaflet)
library(hms)
library(dplyr)



dt_hospital_by_hour = read_xlsx('./data/hse.xlsx', sheet = 'by_hour')
dt_hospital_by_hour = setDT(dt_hospital_by_hour)
setnames(dt_hospital_by_hour, "Time of the day", "region" )
dt_hospital_by_hour = melt(dt_hospital_by_hour, 
     id.vars = "region", 
     variable.name = "time", 
     value.name = "count")
dt_hospital_by_hour$time = as.numeric(dt_hospital_by_hour$time)

dt_hospital_by_day = read_xlsx('./data/hse.xlsx', sheet = 'by_day')
dt_hospital_by_day = setDT(dt_hospital_by_day)
setnames(dt_hospital_by_day, "Day of the week", "region" )
dt_hospital_by_day = melt(dt_hospital_by_day, 
                           id.vars = "region", 
                           variable.name = "day", 
                           value.name = "count")

dt_hospital_by_month = read_xlsx('./data/hse.xlsx', sheet = 'by_month')
dt_hospital_by_month = setDT(dt_hospital_by_month)
setnames(dt_hospital_by_month, "Month of the week", "region" )
dt_hospital_by_month = melt(dt_hospital_by_month, 
                          id.vars = "region", 
                          variable.name = "month", 
                          value.name = "count")

dt_widnes_population = read_xlsx("./data/ons_bua.xlsx", sheet = "population_size", skip = 2)
dt_widnes_population = setDT(dt_widnes_population)
dt_widnes_population = dt_widnes_population[`BUA name` == "Widnes"]

dt_widnes_age = read_xlsx("./data/ons_bua.xlsx", sheet = "age_group", skip = 2)
dt_widnes_age = setDT(dt_widnes_age)
dt_widnes_age = dt_widnes_age[`BUA name` == "Widnes"]
dt_widnes_age = dt_widnes_age[(Age != 'Aged 4 years and under') & (Age != 'Aged 5 to 9 years')]

dt_widnes_age_median = read_xlsx("./data/ons_bua.xlsx", sheet = "median_age", skip = 2)
dt_widnes_age_median = setDT(dt_widnes_age_median)
dt_widnes_age_median = dt_widnes_age_median[`BUA name` == "Widnes"]

dt_widnes_employment = read_xlsx("./data/ons_bua.xlsx", sheet = "employment", skip = 2)
dt_widnes_employment = setDT(dt_widnes_employment)
dt_widnes_employment = dt_widnes_employment[`BUA name` == "Widnes"]

dt_widnes_occupation = read_xlsx("./data/ons_bua.xlsx", sheet = "occupation", skip = 2)
dt_widnes_occupation = setDT(dt_widnes_occupation)
dt_widnes_occupation = dt_widnes_occupation[`BUA name` == "Widnes"]

# HYPERLINK page
websitelink = data.table(url = c("https://www.lcrmusicboard.co.uk/venues-map/", "www.google.com"),
                heading = c("Music Map", "Air Quality"))
websitelink$link <- paste0("<a href='", websitelink$url, "' target='_blank'>", websitelink$heading, "</a>") # to parse hyperlink data


