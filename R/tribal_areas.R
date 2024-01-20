library(tigris)
library(tidyverse)
library(sf)
library(leaflet)
library(janitor)

options(tigris_use_cache = TRUE)

# Download files

# MNDOT's GIS Commons shapefile
download.file("https://resources.gisdata.mn.gov/pub/gdrs/data/pub/us_mn_state_dot/bdry_tribal_government/shp_bdry_tribal_government.zip", "data/MNDOT interpreted tribal areas.zip")

unzip("data/MNDOT interpreted tribal areas.zip", exdir = "tmp")


# MPCA EJ Tribal areas
download.file("https://resources.gisdata.mn.gov/pub/gdrs/data/pub/us_mn_state_pca/env_ej_mpca_census/shp_env_ej_mpca_census.zip", "data/MPCA EJ tribal areas.zip")

unzip("data/MPCA EJ tribal areas.zip", exdir = "tmp")


if FALSE {
# Get latest US Census shapefile
ai_geos <- native_areas(year = 2022, cb = TRUE)

# If more detailed borders needed for spatial analysis, 
# Switch to 'cb = FALSE'
#ai_geos_detailed <- native_areas(year = 2020, cb = FALSE)

names(ai_geos)

plot(ai_geos[,1])

mn <- states(cb = TRUE) %>% 
      filter(GEOID == 27)

plot(mn[,2])


# Flat Earth
sf_use_s2(FALSE)

# Filter to ai_geos that overlap MN
## Add negative buffer to exclude border intersections
mn_ai_geos_rows <- st_intersects(st_buffer(mn, -0.0001)[,1], ai_geos) %>% unlist

mn_ai_geos <- ai_geos[mn_ai_geos_rows, ]

plot(mn[,1])
plot(mn_ai_geos[,4])

leaflet(mn) %>%
  addPolygons(stroke=0, opacity = 1) %>%
  addPolygons(data = mn_ai_geos_detailed %>% mutate(COLOR = mncolors::mncolors(nrow(mn_ai_geos_detailed), palette = 'primary_extended')) %>% filter(NAME == "St. Croix"),
              stroke = 0.25,
              color = "gray",
              fillColor = ~COLOR,
              fillOpacity = 0.6,
              opacity = 0.5,
              popup = ~NAME,
              label = ~NAME,
              labelOptions = labelOptions(noHide=TRUE))

names(mn_ai_geos)

# Drop areas beyond MN border
mn_ai_geos <- st_intersection(st_buffer(mn, -0.0001)[,1], ai_geos)

plot(mn_ai_geos[,4])

leaflet(mn) %>%
  addPolygons(stroke=0, opacity = 1) %>%
  addPolygons(data = mn_ai_geos %>% mutate(COLOR = mncolors::mncolors(nrow(mn_ai_geos), palette = 'primary_extended')),
              stroke = 0.25,
              color = "gray",
              fillColor = ~COLOR,
              fillOpacity = 0.6,
              opacity = 0.5,
              popup = ~NAME,
              label = ~NAME,
              labelOptions = labelOptions(noHide=TRUE))

# Clean data columns
mn_ai_geos <- mn_ai_geos %>%
           select(-ALAND, -AWATER) %>%
           janitor::clean_names() %>%
           select(name, everything())
              
# SAVE 
st_write(mn_ai_geos, "simplified_census_2020_american_indian_geographies.shp")

# Review
aa <- st_read("tmp/Tribal_Government__in_Minnesota.shp")

plot(aa[,1])
}
