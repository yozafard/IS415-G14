gwr_ui <- tabPanel(
  "GWR",
  titlePanel("GWR"),
  
  sidebarLayout(
    sidebarPanel(
      numericInput("numgwr", "GWR Numeric Input:", 1, 100, 50),
      selectInput(
        inputId = "points", 
        label = "Points to Show:", 
        choices = c("Local_R2", "size", "size_SE"),
        selected = "size")
    ),
    mainPanel(
      shinycssloaders::withSpinner(tmapOutput("GWRPlot"), type = 8, color = "#2caa4a")
    )
  )
)