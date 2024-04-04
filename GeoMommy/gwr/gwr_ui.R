gwr_ui <- tabPanel(
  "GWR",
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "coef", 
        label = "Select Cofficient to Plot:", 
        choices = c("Local_R2", "size", "size_SE"),
        selected = "size"),
      selectInput(
        inputId = "bw", 
        label = "Select Type of Bandwidth:", 
        choices = c("Fixed", 'Adaptive'),
        selected = "Fixed"),
      selectInput(
        inputId = "bwc", 
        label = "Select Bandwidth Calibration Method:", 
        choices = c("Cross-Validation", 'Least Akaike Information Criterion'),
        selected = "Cross-Validation"),
      selectInput(
        inputId = "dist", 
        label = "Select Distance Metric:", 
        choices = c("Euclidean", 'Manhattan'),
        selected = "Euclidean"),
      selectInput(
        inputId = "kernel", 
        label = "Select Kernel Function:", 
        choices = c("Fixed", 'Adaptive'),
        selected = "Fixed"),
      selectInput(
        inputId = "dist", 
        label = "Select Distance Metric:", 
        choices = c("Fixed", 'Adaptive'),
        selected = "Fixed")
    ),
    mainPanel( 
      tabsetPanel(
        tabPanel(
          "Geographically Weighted Regression",
          shinycssloaders::withSpinner(tmapOutput("GWRPlot"), type = 8, color = "#2caa4a")
        ),
        tabPanel(
          "Multiple Linear Regression",
          # shinycssloaders::withSpinner(tmapOutput("GWRPlot"), type = 8, color = "#2caa4a")
        ),
      )
    )
  )
)