#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#

# Define UI for application that draws a histogram
kde_ui <- fluidPage(
  # Sidebar with controls
  sidebarLayout(
    sidebarPanel(
      # Dropdown for selecting a city
      selectInput("city",
                  "Select City:",
                  choices = c("Select All" = "DKI Jakarta", "West Jakarta" = "Kota Jakarta Barat", "East Jakarta" = "Kota Jakarta Timur", "North Jakarta" = "Kota Jakarta Utara", "South Jakarta" = "Kota Jakarta Selatan", "Central Jakarta" = "Kota Jakarta Pusat"),
                  selected = c("DKI Jakarta")
      ),
      
      # Slider for selecting bandwidth
      sliderInput("bandwidth",
                  "Select Bandwidth (in kilometres):",
                  min = 0.25,
                  max = 5,
                  value = 0.5,
                  step = 0.25),
      
      # Dropdown for selecting a kernel method
      selectInput("kernel",
                  "Select Kernel Method:",
                  choices = c("Gaussian" = "gaussian", 
                              "Epanechnikov" = "epanechnikov", 
                              "Quartic" = "quartic", 
                              "Disc" = "disc"))
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        tabPanel(
          "Kernel Density Estimation",
          shinycssloaders::withSpinner(plotOutput("kdePlot"), type = 8, color = "#2caa4a")
        ),
        tabPanel(
          "Variable Distribution",
          # 
        ),
        tabPanel(
          "Correlation Plot",
          # 
        ),
        tabPanel(
          "Data Table",
          # 
        )
      )
    )
  )
)
