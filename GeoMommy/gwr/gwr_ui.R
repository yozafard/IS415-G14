coef_choices <- c("gender", "size", "building_year", "prox_airport", "prox_gereja", "prox_kantorpos", "prox_kesehatan", "prox_masjid", "prox_stasiunka", "prox_vihara", "pendidikan_within_med", "pura_within_med")
mlr_choices <- c("fitted values", "actual values", "residuals")

gwr_ui <- tabPanel(
  "GWR",
  sidebarLayout(
    sidebarPanel(
      conditionalPanel(
        condition = "input.tabSelected == 'gwr'",
        selectInput(
          inputId = "gwr_coef", 
          label = "Select Cofficient to Plot:", 
          choices = coef_choices,
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
          inputId = "gwr_kernel", 
          label = "Select Kernel Function:", 
          choices = c("Gaussian", 'Exponential', 'Bisquare', 'Tricube', 'Boxcar'),
          selected = "Gaussian"),
      ),
      conditionalPanel(
        condition = "input.tabSelected == 'mlr'",
        selectInput(
          inputId = "mlr_coef", 
          label = "Select Cofficient to Plot:", 
          choices = mlr_choices,
          selected = "fitted values"),
      )
    ),
    mainPanel( 
      tabsetPanel(
        id = "tabSelected",
        tabPanel(
          "Geographically Weighted Regression",
          value = "gwr",
          shinycssloaders::withSpinner(tmapOutput("GWRPlot"), type = 8, color = "#2caa4a")
        ),
        tabPanel(
          "Multiple Linear Regression",
          value = "mlr",
          shinycssloaders::withSpinner(tmapOutput("MLRDPlot"), type = 8, color = "#2caa4a")
        ),
      )
    )
  )
)