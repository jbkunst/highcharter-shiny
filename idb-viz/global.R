library(shinydashboard)
library(shinythemes)
library(shiny)
library(tidyverse)
library(highcharter)
library(forcats)
library(viridisLite)

options(
  shiny.launch.browser = TRUE,
  highcharter.theme = hc_theme_smpl()
)

data <- readRDS("data.rds")
data

opts <- data %>% 
  distinct(fips, name) %>%
  { setNames(.$fips, .$name)}


fmtnum <- function(x = 12312414){
  prettyNum(x, big.mark = ",")
}

thm_spark <- function(...){
  hc_theme_sparkline(
    plotOptions = list(
      series = list(animation = FALSE),
      area = list(
        marker = list(enabled = FALSE),
        states = list(hover = list(lineWidthPlus = 1))
        )
      ),
    tooltip = list(enabled = FALSE),
    xAxis = list(visible = FALSE),
    yAxis = list(visible = FALSE),
    ...
  )
}