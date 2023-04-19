library(tigris)
library(tidyverse)
library(stringr)
library(sf)

mn_counties <- counties("MN")

names(mn_counties)

mn_counties <- mn_counties %>%
               st_set_geometry(NULL) %>%
               mutate(state_fips = 27) %>%
               select(state_fips,
                      county_fips = COUNTYFP,
                      fips = GEOID,
                      county_name = NAME) %>%
               arrange(fips)

# Alternative spellings
mn_counties_alt <- mn_counties %>% 
               mutate(county_name_census = county_name,
                      county_name_no_dots = str_replace_all(county_name, "[.]", ""),
                      county_name_no_spaces = str_replace_all(county_name, " ", ""),
                      county_name_no_dots_no_spaces = str_replace_all(county_name_no_dots, " ", ""),
                      
                      county_name_caps = toupper(county_name),
                      county_name_caps_no_dots = toupper(county_name_no_dots),
                      county_name_caps_no_spaces = toupper(county_name_no_spaces),
                      county_name_caps_no_dots_no_spaces = toupper(county_name_no_dots_no_spaces),
                      
                      county_name_lower = tolower(county_name),
                      county_name_lower_no_dots = tolower(county_name_no_dots),
                      county_name_lower_no_spaces = tolower(county_name_no_spaces),
                      county_name_lower_no_dots_no_spaces = tolower(county_name_no_dots_no_spaces),
                      
                      county_name_title = str_to_title(county_name),
                      county_name_title_no_dots = str_replace_all(county_name_title, "[.]", ""), 
                      county_name_title_no_spaces = str_replace_all(county_name_title, " ", ""),
                      county_name_title_no_dots_no_spaces = str_replace_all(county_name_title_no_dots, " ", ""))

# Pivot longer
mn_counties_long <- pivot_longer(mn_counties_alt, 
                                 county_name_census:county_name_title_no_dots_no_spaces, 
                                 values_to = "alt_spelling") %>%
                    select(-name)

# Drop duplicates
mn_counties_long <- mn_counties_long  %>%
                    group_by(alt_spelling) %>%
                    slice_head(n = 1) %>%
                    arrange(fips)

# SAVE 
write_csv(mn_counties, "County FIPS reference table.csv")
write_csv(mn_counties_long, "County names - Join alt spellings.csv")
