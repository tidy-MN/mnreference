library(tigris)
library(tidyverse)
library(sf)
library(janitor)
library(leaflet)

source("R/census_tracts.R")

# Tracts
tracts <- st_read("Census Tract polygons 2020 simplified.shp") %>% 
  st_transform(26915) 

tracts$tract_area <- st_area(tracts) %>% set_units(mi^2)

# Districts from MNGEO GIS commons

## House
download.file("https://resources.gisdata.mn.gov/pub/gdrs/data/pub/us_mn_state_lcc/bdry_housedistricts2022/shp_bdry_housedistricts2022.zip", "leg_house_districts.zip")

unzip("leg_house_districts.zip")

house <- st_read("house2022.shp")


## Senate
download.file("https://resources.gisdata.mn.gov/pub/gdrs/data/pub/us_mn_state_lcc/bdry_senatedistricts2022/shp_bdry_senatedistricts2022.zip", "leg_senate_districts.zip")

unzip("leg_senate_districts.zip")

senate <- st_read("senate2022.shp") 

senate$sen_areas <- st_area(senate) %>% set_units(mi^2)

# Senate + Tracts

## Test a single district
a <- st_intersection(tracts, 
                     filter(senate, DISTRICT == "05") %>%
                        st_buffer(-10))

plot(a[,1])

## All districts 
sen_tracts <- st_intersection(tracts %>% st_buffer(-30), 
                              senate %>% st_buffer(-30))

sen_tracts$sub_area <- st_area(sen_tracts) %>% set_units(mi^2)

# Drop irrelevant fractions
## < 0.5%
sen_tracts <- sen_tracts %>%
              mutate(frx_tract_in_district = as.numeric(sub_area / tract_area))

sen_tracts <- sen_tracts %>% filter(frx_tract_in_district > 0.005)

leaflet(sen_tracts %>% arrange(geoid) %>% slice_head(n = 2) %>% st_transform(4326) %>% mutate(geoid = c(geoid[1], ""))) %>%
  addPolygons(data = filter(senate, DISTRICT %in% c('07','10')) %>% st_transform(4326),
              fillColor = c("tomato", "orange"),
              color = "gray",
              weight = 0.5,
              popup = ~DISTRICT,
              label = ~paste("Senate District", DISTRICT),
              labelOptions = labelOptions(noHide = TRUE)) %>%
  addPolygons(fillColor = "white",
              stroke = "white",
              popup = ~geoid,
              label = c("Tract 27001770100", NA),
              weight = 2,
              labelOptions = labelOptions(noHide = TRUE)) %>%
  addProviderTiles(providers$CartoDB.Positron, options = providerTileOptions(opacity = 0.75))
  
  