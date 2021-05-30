library(tidyverse)

apps <- dir(here::here(), full.names = TRUE) %>% 
  str_subset("highcharter-shiny.Rproj", negate = TRUE) %>% 
  str_subset("deploy_apps.R", negate = TRUE) 

walk(apps, function(app = "D:/Git/highcharter-shiny/03-events"){
  
  message(app)
  
  rsconnect::deployApp(appDir = app, logLevel = "verbose", forceUpdate = TRUE)
  
})
  
