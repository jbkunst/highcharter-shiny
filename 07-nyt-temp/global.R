library(shiny)
library(bslib)
library(highcharter)
library(readr)
library(dplyr)
library(tidyr)
library(stringr)
library(forcats)
library(purrr)
library(rmarkdown)

app_theme <- bs_theme(
  version = 5,
  bootswatch = "flatly",
  primary = "#47475c",
  secondary = "#73738c",
  success = "#a3edba",
  bg = "#f7f8fb",
  fg = "#47475c"
)

options(highcharter.theme = hc_theme_smpl())

langs <- getOption("highcharter.lang")
langs$loading <- "<i class='fas fa-circle-notch fa-spin fa-4x'></i>"
options(highcharter.lang = langs)

url_base <- "http://graphics8.nytimes.com/newsgraphics/2016/01/01/weather"

cities <- file.path(url_base, "656641daa55247f6c606970a6b7e702e3fd4dcb8/cities_loc_new.csv") %>%
  read_csv(
    col_types = cols(
      station = col_character(),
      state_fullname = col_character(),
      name = col_character(),
      state = col_character(),
      latitude = col_double(),
      longitude = col_double(),
      id = col_character()
    )
  ) %>%
  sample_frac(1) %>%
  mutate(text = paste0(name, ", ", state))

citiesv <- setNames(cities$id, cities$text)
