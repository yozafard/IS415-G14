library(shiny)

# UI
source('kde/kde_ui.R', local = TRUE)
source('gwr/gwr_ui.R', local = TRUE)
source('gwrf/gwrf_ui.R', local = TRUE)

# Define the UI for the application
ui <- fluidPage(
  
  # Application title
  titlePanel("GeoMommy"),
  
  # Main layout with tabbed features
  mainPanel(
    tabsetPanel(
      # Tab for each feature
      kde_ui,
      gwr_ui,
      gwrf_ui
    )
  )
)

# The server logic will remain the same, sourcing external files for features
server <- function(input, output) {
  source("kde/kde.R", local = TRUE)
  source("gwr/gwr.R", local = TRUE)
  source("gwrf/gwrf.R", local = TRUE)
}

# Run the application 
shinyApp(ui = ui, server = server)