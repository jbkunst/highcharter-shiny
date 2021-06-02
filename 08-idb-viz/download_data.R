library(tidyverse)
library(idbr)
library(countrycode)
idb_api_key("35f116582d5a89d11a47c7ffbfc2ba309133f09d")

library(idbr)
data(variables5, package = "idbr")
data(codelist, package = "countrycode")

YRS <- 1990:2050

codelist <- tbl_df(codelist)
codelist

iso2c <- as.character(na.omit(codelist$iso2c))

iso2c_valid <- map_chr(sample(iso2c), function(x){ # x <- "AL"
  message(x)
  try({ 
    get_idb(x, year = 1990)
    return(x) 
    })
})

iso2c_valid <- iso2c_valid[nchar(iso2c_valid) == 2]

codelist %>% 
  select(-starts_with("cldr"), -starts_with("un")) %>% 
  glimpse()

countries <- codelist %>% 
  filter(iso2c %in% iso2c_valid) %>% 
  select(iso2c, iso3c, country = country.name.en)

saveRDS(countries, here::here("08-idb-viz/countries.rds"))
