gwr_ui <- tabPanel(
  "GWR",
  titlePanel("GWR"),
  
  sidebarLayout(
    sidebarPanel(
      numericInput("numgwr", "GWR Numeric Input:", 1, 100, 50)
    ),
    mainPanel(
      plotOutput("GWRPlot")
    )
  )
)