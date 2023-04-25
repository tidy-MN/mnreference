# mnreference :earth_africa::clipboard:

Get MN reference data for populations, demographics, and geographic boundaries.

<br>

# Data

|Topic     |Data                                               | Filename | Last updated | Update schedule |
|:---------|:--------------------------------------------------|:---------|:---------|:---------|
|Census    | **ACS Populations 2017-2021**                         | [*state/county/tract/zcta*_populations_acs_2017_2021.csv](data/) | Jan, 2023 | Annually (Jan) |
|Geography | County FIPS reference table                       | [County FIPS Reference Table.csv](data/County%20FIPS%20Reference%20Table.csv) | Apr, 2023 |	None |
|Geography | County names for joining (alternate spellings)    | [County names - Join alt spellings.csv](data/County%20names%20-%20Join%20alt%20spellings.csv) | Apr, 2023 |	None |
|Geography | Tracts in MN - Census 2020                        | [Census Tract polygons 2020 simplified.zip](data/Census%20Tract%20polygons%202020%20simplified.zip) | Feb, 2022 |	10 years |
|Geography | **ZIP Code Tabulation Areas - Census 2020**          | [Census Zip-ZCTA polygons 2020 simplified.zip](data/Census%20Zip-ZCTA%20polygons%202020%20simplified.zip) | Feb, 2022	| 10 years |
|Geography | MN interpreted Tribal areas - 2023                | [MN interpreted tribal areas.zip](data/MNDOT%20interpreted%20tribal%20areas.zip) | Apr, 2023	| Annually (Apr) | 
|Geography | MPCA EJ Tribal areas - 2023                       | [MPCA EJ tribal areas.zip](data/MPCA%20EJ%20tribal%20areas.zip) | Apr, 2023 |	Annually (Apr) |
|Geography | City Tracts - Census 2020 | (Help Wanted) | | 10 years |
|Geography | City ZIP - ZCTAs - Census 2020 | (Help Wanted)  | | 10 years |

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
tract_pops <- read_csv("https://github.com/tidy-MN/mnreference/raw/main/data/zcta_populations_acs_2017_2021.csv")


# County FIPS reference
county_fips <- read_csv("https://raw.githubusercontent.com/tidy-MN/mnreference/main/data/County%20FIPS%20Reference%20Table.csv")


# County names - Join reference with alt spellings
county_join <- read_csv("https://raw.githubusercontent.com/tidy-MN/mnreference/main/data/County%20names%20-%20Join%20alt%20spellings.csv")
```

<br>

### Shapefiles :earth_africa:

```r
library(sf)

# Census Tracts
download.file("https://github.com/tidy-MN/mnreference/raw/main/data/Census%20Tract%20polygons%202020%20simplified.zip", 
              "Census Tract polygons 2020 simplified.zip")

unzip("Census Tract polygons 2020 simplified.zip")


# Census ZIP-ZCTAs
download.file("https://github.com/tidy-MN/mnreference/raw/main/data/Census%20Zip-ZCTA%20polygons%202020%20simplified.zip", 
              "Census Zip-ZCTA polygons 2020 simplified.zip")

unzip("Census Zip-ZCTA polygons 2020 simplified.zip")


# MNDOT interpreted tribal areas
download.file("https://github.com/tidy-MN/mnreference/raw/main/data/MNDOT%20interpreted%20tribal%20areas.zip", 
              "Census Zip-ZCTA polygons 2020 simplified.zip")

unzip("MNDOT interpreted tribal areas.zip")


# MPCA EJ tribal areas
download.file("https://github.com/tidy-MN/mnreference/raw/main/data/MPCA%20EJ%20tribal%20areas.zip", 
              "MPCA EJ tribal areas.zip")

unzip("MPCA EJ tribal areas.zip")
```
