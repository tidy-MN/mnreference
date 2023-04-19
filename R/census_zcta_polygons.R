library(tigris)
library(tidyverse)
library(sf)
library(janitor)

options(tigris_use_cache = TRUE)

# Download files
zcta <- zctas(year = 2020, cb = TRUE)

# If more detailed borders needed for spatial analysis, 
# Switch to 'cb = FALSE'
#zcta_detailed <- zctas(year = 2020, cb = FALSE)

names(zcta)

mn <- states(cb = TRUE) %>% 
      filter(GEOID == 27)

plot(mn[ ,2])

# Flat Earth
sf_use_s2(FALSE)

# Transform to UTM
mn <- st_transform(mn, 26915)
zcta <- st_transform(zcta, 26915)

# Filter to ZCTAs that overlap MN
mn_zip_rows <- st_intersects(st_buffer(mn[,1], -0.001), zcta) %>% 
               unlist

mn_zcta <- zcta[mn_zip_rows, ]

plot(mn_zcta[,2])

# Switch to st_intersection() to crop to areas within MN 
mn_zcta <- st_intersection(st_buffer(mn[,1], -1), zcta)

plot(mn_zcta[,2])

mn_zcta <- st_transform(mn_zcta, 4269)

names(mn_zcta)

# Clean data columns
mn_zcta <- mn_zcta %>%
           select(-ALAND20, -AWATER20, -LSAD20, -NAME20) %>%
           clean_names() %>%
           rename(zcta5_2020 = zcta5ce20)
              
# SAVE 
write_csv(mn_zcta[, "ZCTA5CE20"], "Census 2020 ZCTA5 list.csv")
st_write(mn_zcta, "simple_census_2020_zcta_polygons.shp")

# Review
aa <- st_read("simple_census_2020_zcta_polygons.shp")

plot(aa[,1])
