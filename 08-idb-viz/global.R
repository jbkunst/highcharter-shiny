# packages ----------------------------------------------------------------
library(shiny)
library(shinydashboard)
library(tidyverse)
library(highcharter)
library(htmltools)
library(shinyWidgets)
library(idbr)

# parameters & helpers ----------------------------------------------------
idb_api_key("35f116582d5a89d11a47c7ffbfc2ba309133f09d")

langs <- getOption("highcharter.lang")

langs$loading <- "<i class='fas fa-circle-notch fa-spin fa-4x'></i>"

options(highcharter.lang = langs)

options(highcharter.theme = hc_theme_smpl())

countries <- readRDS("countries.rds")

opts <- countries %>% 
  sample_frac(1) %>% 
  select(country, iso2c) %>%
  deframe()

BRKS <- seq(0, 100, length.out = 10 + 1)
YRS  <- seq(1985, 2025, by = 1)

data_from_fips <- function(iso2 = "CL") {
  
  data <- get_idb(
    iso2, 
    year = YRS, 
    age = 1:100,
    # variables = c("AGE", "POP"), 
    sex = c("both")
    )
  
  datag <- data %>% 
    mutate(agec = cut(age, breaks = BRKS, include.lowest = TRUE)) %>% 
    group_by(year, agec) %>% 
    summarise(
      pop = sum(pop),
      age_median = round(median(age)),
      .groups = "drop"
    ) %>% 
    ungroup() %>% 
    arrange(desc(age_median)) %>% 
    mutate(
      birth_year = year - age_median, 
      agec = fct_inorder(agec)
    ) %>% 
    select(year, pop, agec, age_median) %>% 
    arrange(year, age_median) %>% 
    mutate(
      agec = fct_inorder(agec),
      agec = fct_rev(agec)
      )
  
  # datag %>% count(agec)
  
  datag <- datag %>% 
    select(x = year, y = pop, agec)
  
  datag
  
}

dstart <- data_from_fips()

COLORS <- viridisLite::inferno(length(BRKS) - 1, begin = 0.1, end = .9) %>% 
  hex_to_rgba() %>%
  rev()

COLORS <- dstart %>% 
  distinct(agec) %>% 
  mutate(color = COLORS) %>% 
  deframe()

hc <- hchart(dstart, "area", hcaes(x = x, y = y, group = agec)) %>% 
  hc_colors(as.character(rev(COLORS))) %>% 
  hc_xAxis(
    title = list(text = "Year"),
    crosshair = list(color = "yellow", label = list(enabled = TRUE, format = "{value}"))
    ) %>% 
  hc_yAxis(
    title = list(text = "Population"),
    crosshair = list(label = list(enabled = TRUE, format = "{value:,.0f}"))
    ) %>% 
  hc_plotOptions(
    series = list(
      showInLegend = FALSE,
      stacking = "normal",
      lineColor = "white",
      lineWidth = 0.5,
      # pointStart = min(YRS),
      # pointInterval = unique(diff(YRS)),
      marker = list(symbol = "circle", size = 0.1, enabled = FALSE, lineWidth = 0)
    )
  ) %>% 
  hc_add_event_series(event = "mouseOver")

hc

dstart2 <- dstart %>% 
  filter(agec == "[0,10]") %>% 
  select(-agec)

hc_agec <-  hchart(dstart2, "line", hcaes(x = x, y = y), id = 0) %>% 
  hc_xAxis(title = list(text = "Year")) %>% 
  hc_yAxis(title = list(text = "Population"), min = 0)
  
hc_agec
