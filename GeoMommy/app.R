pacman::p_load(shiny, shinycssloaders, car, olsrr, corrplot, ggpubr, sf, spdep, GWmodel, tmap, tidyverse, gtsummary)

# UI
source('kde/kde_ui.R', local = TRUE)
source('gwr/gwr_ui.R', local = TRUE)
source('gwrf/gwrf_ui.R', local = TRUE)

# Define the UI for the application
ui <- fluidPage(
  navbarPage("GeoMommy",
    tabPanel("KDE", kde_ui), 
    tabPanel("GWR", gwr_ui),
    tabPanel("GWRF", gwrf_ui)
  )
)

server <- function(input, output) {
  source("kde/kde.R", local = TRUE)
  source("gwr/gwr.R", local = TRUE)
  source("gwrf/gwrf.R", local = TRUE)
}

# Run the application 
shinyApp(ui = ui, server = server)