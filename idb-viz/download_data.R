library(tidyverse)
library(idbr)
library(countrycode)
idb_api_key("35f116582d5a89d11a47c7ffbfc2ba309133f09d")

data(countrycode_data)
YRS <- 1990:2050


countrycode_data <- tbl_df(countrycode_data)
countrycode_data

fips <- na.omit(countrycode_data$fips104)

fips_valid <- map_chr(sample(fips), function(x){ # x <- "AL"
  message(x)
  try({ idb1(x, 1990, variables = c("AGE", "POP")); return(x) })
})

fips_valid <- fips_valid[nchar(fips_valid) == 2]
  
try(dir.create("data"))
# file.remove(dir("data", full.names = TRUE))
map(sample(fips_valid), function(fip){ # fip <- "US"
  message(fip)
  
  file <- sprintf("data/%s.rds", fip)
  
  if(!file.exists(file)) {
    t0 <- Sys.time()
    
    data <- bind_rows(
      idb1(fip, YRS, variables = c("AGE", "POP", "NAME"), sex = "male"),
      idb1(fip, YRS, variables = c("AGE", "POP", "NAME"), sex = "female") 
    )
    
    data <- mutate(data, SEX = ifelse(SEX == 1, "male", "female"))
    
    saveRDS(data, file)
    
    print(Sys.time() - t0)
    
  }
})

data <- map_df(dir("data", full.names = TRUE), readRDS)
names(data) <- tolower(names(data))

saveRDS(data, "data.rds")


