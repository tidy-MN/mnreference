# mnreference :earth_africa::clipboard:

<br>

> ### Get MN reference data for populations, demographics, and geographic boundaries.

<br>

# Data

|Topic     |Data                                               | Filename | Last updated | Update schedule |
|:---------|:--------------------------------------------------|:---------|:---------|:---------|
|Census    | **ACS Populations 2017-2021**                         | [*state/county/tract/zcta/tribes*_populations_acs_2017_2021.csv](data/) | Jan, 2023 | Annually (Jan) |
|Geography | County FIPS reference table                       | [County FIPS Reference Table.csv](data/county_fips_reference.csv) | Apr, 2023 |	None |
|Geography | County names for joining (alternate spellings)    | [County names - Alt spellings.csv](data/county_names_alt_spellings.csv) | Apr, 2023 |	None |
|Geography | MDH: County SCHSAC regions, NCHS urbran/rural code, and Community Health Boards  | [county_schsac_chbs_and_urban_code.csv](data/county_schsac_chbs_and_urban_code.csv) | May, 2023 |	None |
|Geography | Tracts in MN - Census 2020                        | [Census Tract polygons 2020 simplified.zip](data/Census%20Tract%20polygons%202020%20simplified.zip) | Feb, 2022 |	10 years |
|Geography | **ZIP Code Tabulation Areas - Census 2020**          | [Census Zip-ZCTA polygons 2020 simplified.zip](data/Census%20Zip-ZCTA%20polygons%202020%20simplified.zip) | Feb, 2022	| 10 years |
|Geography | MN interpreted Tribal areas - 2023                | [MN interpreted tribal areas.zip](data/MNDOT%20interpreted%20tribal%20areas.zip) | Jan, 2023	| Annually (Jan) | 
|Geography | MPCA EJ Tribal areas - 2023                       | [MPCA EJ tribal areas.zip](data/MPCA%20EJ%20tribal%20areas.zip) | Oct, 2023 |	Annually (Jan) |
|Geography | School districts - School year 2023/2024 | [School_districts.zip](data/school_districts.zip) | Nov, 2023 |	Annually (Nov) |
|Geography | State Senate districts in MN - 2020 | [senate_districts.zip](data/senate_districts.zip) | Jul, 2022 |	10 years (Census) |
|Geography | State House districts in MN - 2020 | [house_districts.zip](data/house_districts.zip) | Jul, 2022 |	10 years (Census) |
|Geography | City Tracts - Census 2020 | (Coming soon...) | | 10 years |
|Geography | City ZIP - ZCTAs - Census 2020 | (Coming soon...)  | | 10 years |

<br>

# Load data

### CSVs :clipboard:
```r
library(tidyverse)

# State populations
state_pops <- read_csv("https://raw.githubusercontent.com/tidy-MN/mnreference/main/data/state_populations_acs_2017_2021.csv")


# County populations
county_pops <- read_csv("https://raw.githubusercontent.com/tidy-MN/mnreference/main/data/county_populations_acs_2017_2021.csv")


# Tract populations
tract_pops <- read_csv("https://github.com/tidy-MN/mnreference/raw/main/data/tract_populations_acs_2017_2021.csv")


# ZCTA populations
zcta_pops <- read_csv("https://github.com/tidy-MN/mnreference/raw/main/data/zcta_populations_acs_2017_2021.csv")


# Tribes populations
tribes_pops <- read_csv("https://github.com/tidy-MN/mnreference/raw/main/data/tribes_populations_acs_2017_2021.csv")


# County FIPS reference
county_fips <- read_csv("https://raw.githubusercontent.com/tidy-MN/mnreference/main/data/county_fips_reference.csv")


# County names - Join reference with alt spellings
county_join <- read_csv("https://raw.githubusercontent.com/tidy-MN/mnreference/main/data/county_names_alt_spellings.csv")

## Use left_join() to add Census geoids and county names to your data
your_data <- left_join(your_data, county_join, by = c("your_county_column" = "alt_spelling"))


# MDH: County SCHSAC regions, NCHS urbran/rural code, and Community Health Boards
county_schsac <- read_csv("https://raw.githubusercontent.com/tidy-MN/mnreference/main/data/county_schsac_chbs_and_urban_code.csv")
```

<br>

### Shapefiles :earth_africa:

```r
library(sf)

# Census Tracts
options(download.file.method="curl", download.file.extra="-k -L")
download.file("https://github.com/tidy-MN/mnreference/raw/main/data/Census%20Tract%20polygons%202020%20simplified.zip", 
              "Census Tract polygons 2020 simplified.zip")

unzip("Census Tract polygons 2020 simplified.zip")


# Census ZIP-ZCTAs
options(download.file.method="curl", download.file.extra="-k -L")
download.file("https://github.com/tidy-MN/mnreference/raw/main/data/Census%20Zip-ZCTA%20polygons%202020%20simplified.zip", 
              "Census Zip-ZCTA polygons 2020 simplified.zip")

unzip("Census Zip-ZCTA polygons 2020 simplified.zip")


# MNDOT interpreted tribal areas
options(download.file.method="curl", download.file.extra="-k -L")
download.file("https://github.com/tidy-MN/mnreference/raw/main/data/MNDOT%20interpreted%20tribal%20areas.zip", 
              "MNDOT interpreted tribal areas.zip")

unzip("MNDOT interpreted tribal areas.zip")


# MPCA EJ tribal areas
options(download.file.method="curl", download.file.extra="-k -L")
download.file("https://github.com/tidy-MN/mnreference/raw/main/data/MPCA%20EJ%20tribal%20areas.zip", 
              "MPCA EJ tribal areas.zip")

unzip("MPCA EJ tribal areas.zip")


# School districts
options(download.file.method="curl", download.file.extra="-k -L")
download.file("https://github.com/tidy-MN/mnreference/raw/main/data/school_districts.zip", 
              "school_districts.zip")

unzip("school_districts.zip")


# State Senate districts
options(download.file.method="curl", download.file.extra="-k -L")
download.file("https://github.com/tidy-MN/mnreference/raw/main/data/senate_districts.zip", 
              "senate_districts.zip")

unzip("senate_districts.zip")


# State House districts
options(download.file.method="curl", download.file.extra="-k -L")
download.file("https://github.com/tidy-MN/mnreference/raw/main/data/house_districts.zip", 
              "house_districts.zip")

unzip("house_districts.zip")
```
