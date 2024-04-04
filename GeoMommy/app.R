pacman::p_load(shiny, shinycssloaders, car, olsrr, corrplot, ggpubr, sf, spdep, GWmodel, tmap, tidyverse, gtsummary, tidygeocoder)
library(leaflet)
library(leaflet.extras)

# UI
source('kde/kde_ui.R', local = TRUE)
source('gwr/gwr_ui.R', local = TRUE)
source('gwrf/gwrf_ui.R', local = TRUE)

# Define the UI for the application
ui <- fluidPage(
  navbarPage("GeoMommy",
    tabPanel("EDA", kde_ui), 
    tabPanel("Descriptive", gwr_ui),
    tabPanel("Predictive", gwrf_ui)
  )
) 
server <- function(input, output) {
  source("kde/kde.R", local = TRUE)
  source("gwr/gwr.R", local = TRUE)
  source("gwrf/gwrf.R", local = TRUE)
  # Example reactive value for storing search results
  # In a real scenario, this would be a reactive expression that filters your data based on the search query
  
}

# Run the application 
shinyApp(ui = ui, server = server)