library(tidyverse)
library(sf)
library(leaflet)

# Download Sen/House Districts from MNGEO Commons

## House
download.file("https://resources.gisdata.mn.gov/pub/gdrs/data/pub/us_mn_state_lcc/bdry_housedistricts2022/shp_bdry_housedistricts2022.zip", "leg_house_districts.zip")

unzip("leg_house_districts.zip")

house <- st_read("house2022.shp") %>%
         st_transform(4326)

## Senate
download.file("https://resources.gisdata.mn.gov/pub/gdrs/data/pub/us_mn_state_lcc/bdry_senatedistricts2022/shp_bdry_senatedistricts2022.zip", "leg_senate_districts.zip")

unzip("leg_senate_districts.zip")

senate <- st_read("senate2022.shp") %>%
          st_transform(4326)


# Senate map
## Quick map
mapview(senate, zcol = "DISTRICT", smoothFactor = 0.5)

## For more customization
colors <- colorFactor("viridis",
                      fct_shuffle(senate$DISTRICT))

leaflet(senate) %>% 
  addProviderTiles(providers$CartoDB.Positron, options = providerTileOptions(opacity = 0.75)) %>%
  addPolygons(smoothFactor = 0.5,
              fillColor = ~colors(DISTRICT),
              fillOpacity = 0.65,
              color = "gray", # Border color
              weight = 0.5, # Border thickness
              popup = ~paste("Senate District", DISTRICT),
              label = ~paste("Senate District", DISTRICT),
              labelOptions = labelOptions(noHide = FALSE))

  
  