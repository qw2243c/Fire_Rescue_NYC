
library(shiny)

library(leaflet)
library(plotly)

library(choroplethr)
library(choroplethrZip)
library(dplyr)
library(maps)
library(rgdal)
library(plyr)


# data file source - load first
load("../data/Firehouse.RData")
load("../data/Incident_data_selected.RData")

# From https://data.cityofnewyork.us/Business/Zip-Code-Boundaries/i8iw-xf4u/data
NYCzipcodes <- readOGR("../data/ZIP_CODE_040114.shp", verbose = FALSE)


# Borough & zipcode - list
# [1] "BRONX"                    "BROOKLYN"                 "MANHATTAN"                "QUEENS"                  
# [5] "RICHMOND / STATEN ISLAND"
Borough.zipcode <- dlply(incident.data.selected, "INCIDENT_BOROUGH")
f <- function(df) {na.omit(unique(df$ZIPCODE))}
Borough.zipcode <- lapply(Borough.zipcode, f)
names(Borough.zipcode)[5] <- "RICHMOND"

# Incident: zipcode & amount - dataframe
Incident.zipcode.amount <- data.frame(table(incident.data.selected$ZIPCODE))
names(Incident.zipcode.amount) <- c("Incident.zipcode", "Incident.amount")


