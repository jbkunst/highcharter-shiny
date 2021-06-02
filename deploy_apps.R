library(tidyverse)

# remotes::install_github("jbkunst/highcharter", force = TRUE)

apps <- dir(here::here(), full.names = TRUE) %>% 
  str_subset("highcharter-shiny.Rproj", negate = TRUE) %>% 
  str_subset("deploy_apps.R", negate = TRUE) 

walk(apps, function(app = "D:/Git/highcharter-shiny/01-get-sarted"){
  
  message(app)
  
  try(fs::dir_delete(fs::path(app, "rsconnect")))
  
  rsconnect::deployApp(appDir = app, logLevel = "normal")
  
})
  
