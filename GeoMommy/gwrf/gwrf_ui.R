gwrf_ui <- tabPanel(
  "GWRF",
  titlePanel("GWRF"),
  
  sidebarLayout(
    sidebarPanel(
      numericInput("numgwrf", "GWRF Numeric Input:", 1, 100, 50)
    ),
    mainPanel(
      plotOutput("GWRFPlot")
    )
  )
)