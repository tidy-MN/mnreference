library(tidyverse)
library(mapview)
library(sf)
library(leaflet)
library(htmltools)

# Download School Districts from MNGEO Commons
download.file("https://resources.gisdata.mn.gov/pub/gdrs/data/pub/us_mn_state_mde/bdry_school_district_boundaries/shp_bdry_school_district_boundaries.zip", "data/school_districts.zip")

unzip("data/school_districts.zip", exdir = "tmp")

schools <- st_read("tmp/school_district_boundaries.shp") %>%
           st_transform(4326) 

schools <- schools %>%
           rowwise() %>%
           mutate(popup_html = HTML(paste(SHORTNAME,"::", SDORGID,  "<br>", PREFNAME)))

# District map
## Quick map
mapview(schools, zcol = "SDORGID", smoothFactor = 0.5)

## For more customization
colors <- colorNumeric("viridis", schools$SDORGID)

leaflet(schools) %>% 
  addProviderTiles(providers$CartoDB.Positron, 
                   options = providerTileOptions(opacity = 0.75)) %>%
  addPolygons(smoothFactor = 0.5,
              fillColor = ~colors(SDORGID),
              fillOpacity = 0.65,
              color = "gray", # Border color
              weight = 0.5, # Border thickness
              popup = ~popup_html,
              label = ~SHORTNAME,
              labelOptions = labelOptions(noHide = FALSE))

  