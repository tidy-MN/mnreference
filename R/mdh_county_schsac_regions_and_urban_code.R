library(tidyverse)
library(tigris)
library(readxl)
library(httr)
library(janitor)

# Get county list
mn <- counties(27, cb = TRUE)

mn <- select(mn, GEOID, NAME) %>%
      sf::st_set_geometry(NULL) %>%
      mutate(GEOID = as.numeric(GEOID))

# Get NCHS urban/rural code
# Source: NCHS - https://www.cdc.gov/nchs/data_access/urban_rural.htm
urb_url <- "https://www.cdc.gov/nchs/data/data_acces_files/NCHSURCodes2013.xlsx"
  
GET(urb_url, write_disk(tf <- tempfile(fileext = ".xlsx")))

urb <- read_excel(tf, sheet = 1L) %>%
       clean_names() %>% 
       filter(state_abr == "MN") %>%
       rename(nchs_urban_code_2013 = x2013_code)

## Code descriptions
## https://www.cdc.gov/nchs/data/data_acces_files/NCHSUrbruralFileDocumentationInternet2.pdf
urb_cats <- tibble::tribble(
    ~nchs_urban_code_2013,   ~nchs_urban_name_2013, ~nchs_urban_desc_2013,
                     1L, "Large central metro", "NCHS-defined “central” counties of MSAs of 1 million or more population",
                     2L,  "Large fringe metro",  "NCHS-defined “fringe” counties of MSAs of 1 million or more population",
                     3L,        "Medium metro",                     "Counties within MSAs of 250,000- 999,999 population",
                     4L,         "Small metro",                    "Counties within MSAS of 50,000 to 249,999 population",
                     5L,        "Micropolitan",                              "Counties in micropolitan statistical areas",
                     6L,             "Noncore",                      "Counties not within micropolitan statistical areas"
    )
  
urb <- left_join(urb, urb_cats) %>% 
       select(fips_code, 
              nchs_urban_code_2013, 
              nchs_urban_name_2013, 
              nchs_urban_desc_2013)


# Get MDH SCHSAC regions
## https://www.health.state.mn.us/communities/practice/schsac/about.html
schsac <- tibble::tribble(
     ~fips,             ~county,   ~schsac_region_long,
      27001L,            "Aitkin",  "Northeastern",
      27003L,             "Anoka",         "Metro",
      27005L,            "Becker",  "West Central",
      27007L,          "Beltrami",  "Northwestern",
      27009L,            "Benton",       "Central",
      27011L,         "Big Stone",  "Southwestern",
      27013L,        "Blue Earth", "South Central",
      27015L,             "Brown", "South Central",
      27017L,           "Carlton",  "Northeastern",
      27019L,            "Carver",         "Metro",
      27021L,              "Cass",       "Central",
      27023L,          "Chippewa",  "Southwestern",
      27025L,           "Chisago",       "Central",
      27027L,              "Clay",  "West Central",
      27029L,        "Clearwater",  "Northwestern",
      27031L,              "Cook",  "Northeastern",
      27033L,        "Cottonwood",  "Southwestern",
      27035L,         "Crow Wing",       "Central",
      27037L,            "Dakota",         "Metro",
      27039L,             "Dodge",  "Southeastern",
      27041L,           "Douglas",  "West Central",
      27043L,         "Faribault", "South Central",
      27045L,          "Fillmore",  "Southeastern",
      27047L,          "Freeborn",  "Southeastern",
      27049L,           "Goodhue",  "Southeastern",
      27051L,             "Grant",  "West Central",
      27053L,          "Hennepin",         "Metro",
      27055L,           "Houston",  "Southeastern",
      27057L,           "Hubbard",  "Northwestern",
      27059L,            "Isanti",       "Central",
      27061L,            "Itasca",  "Northeastern",
      27063L,           "Jackson",  "Southwestern",
      27065L,           "Kanabec",       "Central",
      27067L,         "Kandiyohi",  "Southwestern",
      27069L,           "Kittson",  "Northwestern",
      27071L,       "Koochiching",  "Northeastern",
      27073L,     "Lac qui Parle",  "Southwestern",
      27075L,              "Lake",  "Northeastern",
      27077L, "Lake of the Woods",  "Northwestern",
      27079L,          "Le Sueur", "South Central",
      27081L,           "Lincoln",  "Southwestern",
      27083L,              "Lyon",  "Southwestern",
      27085L,            "McLeod", "South Central",
      27087L,          "Mahnomen",  "Northwestern",
      27089L,          "Marshall",  "Northwestern",
      27091L,            "Martin", "South Central",
      27093L,            "Meeker", "South Central",
      27095L,        "Mille Lacs",       "Central",
      27097L,          "Morrison",       "Central",
      27099L,             "Mower",  "Southeastern",
      27101L,            "Murray",  "Southwestern",
      27103L,          "Nicollet", "South Central",
      27105L,            "Nobles",  "Southwestern",
      27107L,            "Norman",  "Northwestern",
      27109L,           "Olmsted",  "Southeastern",
      27111L,        "Otter Tail",  "West Central",
      27113L,        "Pennington",  "Northwestern",
      27115L,              "Pine",       "Central",
      27117L,         "Pipestone",  "Southwestern",
      27119L,              "Polk",  "Northwestern",
      27121L,              "Pope",  "West Central",
      27123L,            "Ramsey",         "Metro",
      27125L,          "Red Lake",  "Northwestern",
      27127L,           "Redwood",  "Southwestern",
      27129L,          "Renville",  "Southwestern",
      27131L,              "Rice",  "Southeastern",
      27133L,              "Rock",  "Southwestern",
      27135L,            "Roseau",  "Northwestern",
      27137L,         "St. Louis",  "Northeastern",
      27139L,             "Scott",         "Metro",
      27141L,         "Sherburne",       "Central",
      27143L,            "Sibley", "South Central",
      27145L,           "Stearns",       "Central",
      27147L,            "Steele",  "Southeastern",
      27149L,           "Stevens",  "West Central",
      27151L,             "Swift",  "Southwestern",
      27153L,              "Todd",       "Central",
      27155L,          "Traverse",  "West Central",
      27157L,           "Wabasha",  "Southeastern",
      27159L,            "Wadena",       "Central",
      27161L,            "Waseca", "South Central",
      27163L,        "Washington",         "Metro",
      27165L,          "Watonwan", "South Central",
      27167L,            "Wilkin",  "West Central",
      27169L,            "Winona",  "Southeastern",
      27171L,            "Wright",       "Central",
      27173L,   "Yellow Medicine",  "Southwestern"
  )



## Alternative region formats
schsac_names <- tibble::tribble(
     ~schsac_region_long,   ~schsac_region,   ~schsac_region_split,
      "Minnesota",     "Minnesota",     "Minnesota",
          "Metro",         "Metro",         "Metro",
   "Southeastern",     "Southeast",    "South East",
  "South Central", "South Central", "South Central",
   "Southwestern",     "Southwest",    "South West",
        "Central",       "Central",       "Central",
   "West Central",  "West Central",  "West Central",
   "Northwestern",     "Northwest",    "North West",
   "Northeastern",     "Northeast",    "North East")


schsac <- left_join(schsac, schsac_names) %>%
          select(fips, schsac_region, everything()) %>%
          select(-county)



# Community Health Boards
## Map - https://www.health.state.mn.us/communities/practice/connect/docs/chb.pdf
## Web - https://www.health.state.mn.us/communities/practice/connect/findlph.html
chb <- tibble::tribble(
  ~county_fips,        ~County_name,                    ~com_health_board_long,
        27001L,            "Aitkin",                                                                                                                    "Aitkin-Itasca-Koochiching CHB",
        27003L,             "Anoka",                                                                                                                    "Anoka County Community Health",
        27005L,            "Becker",                                                                                                                               "Partnership4Health",
        27007L,          "Beltrami",                                                                                                                              "Beltrami County CHB",
        27009L,            "Benton",                                                                                                                   "Benton County Community Health",
        27011L,         "Big Stone",                                                                                                                        "Countryside Public Health",
        27013L,        "Blue Earth",                                                                                                                         "Blue Earth County Health",
        27015L,             "Brown",                                                                                                                               "Brown-Nicollet CHB",
        27017L,           "Carlton",                                                                                                                   "Carlton-Cook-Lake-St.Louis CHB",
        27019L,            "Carver",                                                                                                                                           "Carver",
        27021L,              "Cass",                                                                                                                                  "Cass County PHS",
        27023L,          "Chippewa",                                                                                                                        "Countryside Public Health",
        27025L,           "Chisago",                                                                                                                                   "Chisago County",
        27027L,              "Clay",                                                                                                                               "Partnership4Health",
        27029L,        "Clearwater",                                                                                                                                "North Country CHB",
        27031L,              "Cook",                                                                                                                   "Carlton-Cook-Lake-St.Louis CHB",
        27033L,        "Cottonwood",                                                                                                      "Des Moines Valley Health and Human Services",
        27035L,         "Crow Wing",                                                                                                                         "Crow Wing Health Service",
        27037L,            "Dakota",                                                                                                           "Dakota County Public Health Department",
        27039L,             "Dodge",                                                                                                                                 "Dodge-Steele CHB",
        27041L,           "Douglas",                                                                                                                   "Horizon Community Health Board",
        27043L,         "Faribault",                                                                                                               "Human Services of Faribault-Martin",
        27045L,          "Fillmore",                                                                                                                             "Fillmore-Houston CHB",
        27047L,          "Freeborn",                                                                                                    "Freeborn County Public Health Nursing Service",
        27049L,           "Goodhue",                                                                                                            "Goodhue County Public Health Services",
        27051L,             "Grant",                                                                                                                   "Horizon Community Health Board",
        27053L,          "Hennepin", "Hennepin County Public Health (Bloomington, Edina, Minneapolis, and Richfield are independent health departments located within Hennepin County)",
        27055L,           "Houston",                                                                                                                             "Fillmore-Houston CHB",
        27057L,           "Hubbard",                                                                                                                                "North Country CHB",
        27059L,            "Isanti",                                                                                                             "Isanti County Community Health Board",
        27061L,            "Itasca",                                                                                                                    "Aitkin-Itasca-Koochiching CHB",
        27063L,           "Jackson",                                                                                                      "Des Moines Valley Health and Human Services",
        27065L,           "Kanabec",                                                                                                                  "Kanabec County Community Health",
        27067L,         "Kandiyohi",                                                                                                      "Kandiyohi - Renville Community Health Board",
        27069L,           "Kittson",                                                                                                             "Quin County Community Health Service",
        27071L,       "Koochiching",                                                                                                                    "Aitkin-Itasca-Koochiching CHB",
        27073L,     "Lac Qui Parle",                                                                                                                        "Countryside Public Health",
        27075L,              "Lake",                                                                                                                   "Carlton-Cook-Lake-St.Louis CHB",
        27077L, "Lake of the Woods",                                                                                                                                "North Country CHB",
        27079L,          "Le Sueur",                                                                                                                  "LeSueur-Waseca Community Health",
        27081L,           "Lincoln",                                                                                                                "Southwest Health & Human Services",
        27083L,              "Lyon",                                                                                                                "Southwest Health & Human Services",
        27087L,          "Mahnomen",                                                                                                               "Polk-Norman-Mahnomen County Health",
        27089L,          "Marshall",                                                                                                             "Quin County Community Health Service",
        27091L,            "Martin",                                                                                                               "Human Services of Faribault-Martin",
        27085L,            "McLeod",                                                                                                                         "Meeker-McLeod-Sibley CHS",
        27093L,            "Meeker",                                                                                                                         "Meeker-McLeod-Sibley CHS",
        27095L,        "Mille Lacs",                                                                                                         "Mille Lacs County Community Health Board",
        27097L,          "Morrison",                                                                                                                         "Morrison-Todd-Wadena CHB",
        27099L,             "Mower",                                                                                                             "Mower County Health & Human Services",
        27101L,            "Murray",                                                                                                                "Southwest Health & Human Services",
        27103L,          "Nicollet",                                                                                                                               "Brown-Nicollet CHB",
        27105L,            "Nobles",                                                                                                                 "Nobles County Community Services",
        27107L,            "Norman",                                                                                                               "Polk-Norman-Mahnomen County Health",
        27109L,           "Olmsted",                                                                                                            "Olmsted County Public Health Services",
        27111L,        "Otter Tail",                                                                                                                               "Partnership4Health",
        27113L,        "Pennington",                                                                                                             "Quin County Community Health Service",
        27115L,              "Pine",                                                                                                                        "Pine County Public Health",
        27117L,         "Pipestone",                                                                                                                "Southwest Health & Human Services",
        27119L,              "Polk",                                                                                                               "Polk-Norman-Mahnomen County Health",
        27121L,              "Pope",                                                                                                                   "Horizon Community Health Board",
        27123L,            "Ramsey",                                                                                                       "St. Paul-Ramsey County Public Health - WIC",
        27125L,          "Red Lake",                                                                                                             "Quin County Community Health Service",
        27127L,           "Redwood",                                                                                                                "Southwest Health & Human Services",
        27129L,          "Renville",                                                                                                      "Kandiyohi - Renville Community Health Board",
        27131L,              "Rice",                                                                                                       "Rice County Public Health Nursing Services",
        27133L,              "Rock",                                                                                                                "Southwest Health & Human Services",
        27135L,            "Roseau",                                                                                                             "Quin County Community Health Service",
        27139L,             "Scott",                                                                                                                                            "Scott",
        27141L,         "Sherburne",                                                                                                       "Sherburne County Health and Human Services",
        27143L,            "Sibley",                                                                                                                         "Meeker-McLeod-Sibley CHS",
        27137L,       "Saint Louis",                                                                                                                   "Carlton-Cook-Lake-St.Louis CHB",
        27145L,           "Stearns",                                                                                                                    "Stearns County Human Services",
        27147L,            "Steele",                                                                                                                                 "Dodge-Steele CHB",
        27149L,           "Stevens",                                                                                                                   "Horizon Community Health Board",
        27151L,             "Swift",                                                                                                                        "Countryside Public Health",
        27153L,              "Todd",                                                                                                                         "Morrison-Todd-Wadena CHB",
        27155L,          "Traverse",                                                                                                                   "Horizon Community Health Board",
        27157L,           "Wabasha",                                                                                                             "Wabasha County Public Health Service",
        27159L,            "Wadena",                                                                                                                         "Morrison-Todd-Wadena CHB",
        27161L,            "Waseca",                                                                                                                  "LeSueur-Waseca Community Health",
        27163L,        "Washington",                                                                                                                  "Washington County Public Health",
        27165L,          "Watonwan",                                                                                                                   "Watonwan County Human Services",
        27167L,            "Wilkin",                                                                                                                               "Partnership4Health",
        27169L,            "Winona",                                                                                                                               "Winona County PHNS",
        27171L,            "Wright",                                                                                                                                "Wright County CAP",
        27173L,   "Yellow Medicine",                                                                                                                        "Countryside Public Health"
  )

## Short names on webpage
chb <- chb %>%
       mutate(com_health_board = com_health_board_long %>%
                str_remove_all(" CHB| Community Health| County| Public Health Services| Public Health| Health$| PHS| Service$| (?<! Health) Services$| Nursing| Board$| CHS| Community Services| PHNS| - WIC| CAP"),
              com_health_board = case_when(com_health_board == "Quin" ~ "Quin County", 
                                           com_health_board == "Watonwan Human Services" ~ "Watonwan",                                com_health_board == "Horizon" ~ "Horizon Public Health", 
                                           com_health_board == "Stearns Human Services" ~ "Stearns", 
                                           com_health_board == "Mower Health and Human Services" ~ "Mower",
                                           com_health_board == "Human Services of Faribault-Martin" ~ "Human Services of Faribault and Martin Counties",                                 com_health_board_long == "Hennepin County Public Health (Bloomington, Edina, Minneapolis, and Richfield are independent health departments located within Hennepin County)" ~ "Hennepin",                                   TRUE ~com_health_board),
              com_health_board = com_health_board %>% str_replace_all("St.Louis", "St. Louis"),
              com_health_board = com_health_board %>% str_replace_all("&", "and"))


# Join all
## SCHSAC
mn <- left_join(mn, schsac, by = c("GEOID" = "fips"))

## CHB
mn <- left_join(mn, 
                chb %>% select(-County_name, -com_health_board_long), 
                by = c("GEOID" = "county_fips")) 

## NCHS urban score
mn <- left_join(mn, urb, by = c("GEOID" = "fips_code"))


# SAVE
mn <- mn %>%
      rename(county_name = NAME,
             fips = GEOID) %>%
      select(fips, county_name, everything())
      
write_csv(mn, "data/county_schsac_chbs_and_urban_code.csv")
