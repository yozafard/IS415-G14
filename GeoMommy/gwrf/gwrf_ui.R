gwrf_ui <- tabPanel(
  "GWRF",
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "model",
                  label = "Select Model",
                  choices = c("Multiple Linear Regression",
                              "Geographically Weighted Random Forest")),
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

      actionButton(inputId = "predict", label = "Predict", style="color: #fff; background-color: #2caa4a;")
    ),
    mainPanel(fluid = TRUE,
      tabsetPanel(
        tabPanel(
          "Predicting Price",
          fluidRow(
            column(
              width = 12,
              shinycssloaders::withSpinner(leafletOutput("GWRFMap"), type = 8, color = "#2caa4a"
            )
          ), fluidRow(
            column(
              width = 12,
              textOutput("GWRFText")
          )
          ))),
        tabPanel(
          "Model Performance",
          fluidRow(
            column(
              width = 12,
              shinycssloaders::withSpinner(plotOutput("GWRFPlot"), type = 8, color = "#2caa4a"
              )
            ), fluidRow(
              column(
                width = 12,
                textOutput("ModelText"))
            ))
        ),
      )
    )
  )
)


