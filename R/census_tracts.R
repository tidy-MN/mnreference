library(tigris)
library(tidyverse)
library(sf)
library(janitor)

options(tigris_use_cache = TRUE)

# Download files
mn_tracts <- tracts(state = 27, year = 2020, cb = TRUE)

# If more detailed borders needed for spatial analysis, 
# Switch to 'cb = FALSE'
# mn_tracts_detailed <- tracts(year = 2020, cb = FALSE)

names(mn_tracts)

plot(mn_tracts[,2])

names(mn_tracts)

# Clean data columns
mn_tracts <- mn_tracts %>%
             select(-ALAND, -AWATER, -STATE_NAME, -LSAD, -NAME, -NAMELSAD, -STUSPS) %>%
             clean_names() %>%
             select(geoid, everything())
              
# SAVE 
st_write(mn_tracts, "Census Tract polygons 2020 simplified.shp")

# Review
aa <- st_read("Census Tract polygons 2020 simplified.shp")

plot(aa[,1])
