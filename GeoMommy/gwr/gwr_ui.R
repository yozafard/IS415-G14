coef_choices <- c("Gender", "Size", "Year of Construction", 
                  "Proximity to Airport", "Proximity to Church", 
                  "Proximity to Post Office", "Proximity to Health Facilities",
                  "Proximity to Mosque", "Proximity to Railway Station", 
                  "Proximity to Vihara", "Education Facilities Count within Range", 
                  "Pura Count within Range")
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
          selected = "Size"),
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
          label = "Select Values to Plot:", 
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
          shinycssloaders::withSpinner(tmapOutput("GWRPlot"), type = 8, color = "#2caa4a"),
          helpText("This choropleth map shows the average coefficient of the selected variable across all the locations. The color intensity represents the strength of the relationship between the selected variable and the dependent variable. The greener the color, the stronger the positive relationship. Conversely, the redder the color, the stronger the negative relationship.")
        ),
        tabPanel(
          "Multiple Linear Regression",
          value = "mlr",
          fluidRow(
            column(12, shinycssloaders::withSpinner(tmapOutput("MLRDPlot"), type = 8, color = "#2caa4a")),
            column(12, shinycssloaders::withSpinner(DT::dataTableOutput("MLRDCoef"), type = 8, color = "#2caa4a"))
          ),
        ),
      )
    )
  )
)
