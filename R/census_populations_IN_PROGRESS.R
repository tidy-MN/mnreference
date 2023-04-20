library(mdhcensus) # Make public?
library(tidyverse)

mapply(dir.create, c("state", "county", "tract", "zcta"))

year <- 2021
survey <- "acs5"

state_2021 <- get_ref_tables(
  geography = "state",
  year      = year,
  state     = "MN",
  survey    = survey, 
  path      = "state")

county_2021 <- get_ref_tables(
  geography = "county",
  year      = year,
  state     = "MN",
  survey    = survey,
  path      = "county")

tract_2021 <- get_ref_tables(
  geography = "tract",
  year      = year,
  state     = "MN",
  survey    = survey,
  path      = "tract")

# State must be blank for ZCTA call
zcta_2021 <- get_ref_tables(
  geography = "zcta",
  year      = year,
  survey    = survey,
  path      = "zcta")
