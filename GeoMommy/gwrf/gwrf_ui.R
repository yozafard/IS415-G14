gwrf_ui <- tabPanel(
  "GWRF",
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "model",
                  label = "Select Model",
                  choices = c("Geographically Weighted Random Forest",
                              "Multilinear Regression")),
      textInput(inputId = "searchBar",
                label = "Search Location",
                placeholder = "Type address here"),
      selectInput(inputId = "gender",
                  label = "Select type of Gender allowed in the rental unit",
                  choices = c("Mixed - Male & Female" = 0,
                              "Male Only" = 1,
                              "Female Only" = 2),
                  selected = 0),
      numericInput(inputId = "size",
                   label = "Size of the rental unit (m2)",
                   value = 12,
                   min = 1,
                   max = 100,
                   step = 0.25),
      sliderInput(inputId = "building_year",
                  label = "Building Year",
                  min = 1950,
                  max = 2024,
                  value = 2000),
      # submitButton(text = "Predict",
                   # icon("refresh"))
      
    ),
    mainPanel(fluid = TRUE,
      tabsetPanel(
        tabPanel(
          "Predicting Price",
          fluidRow(
            column(
              width = 12,
              shinycssloaders::withSpinner(leafletOutput("GWRFMap")
            )
          ), fluidRow(
            column(
              width = 12,
              textOutput("GWRFText")
          )
          ))),
        tabPanel(
          "Model Performance",
          shinycssloaders::withSpinner(plotOutput("GWRFPlot"))
        ),
      )
    )
  )
)


