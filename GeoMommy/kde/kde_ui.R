library(shiny)
library(shinycssloaders)

# Define UI for application that draws a histogram
kde_ui <- fluidPage(
  # Application title can be added here if needed
  
  # Main layout with tabs
  tabsetPanel(
    # First tab with its own sidebar and main panel
    tabPanel("Kernel Density Estimation",
             sidebarLayout(
               sidebarPanel(
                 # Inputs specific to Kernel Density Estimation
                 selectInput("city",
                             "Select City:",
                             choices = c("Select All" = "DKI Jakarta", 
                                         "West Jakarta" = "Kota Jakarta Barat", 
                                         "East Jakarta" = "Kota Jakarta Timur", 
                                         "North Jakarta" = "Kota Jakarta Utara", 
                                         "South Jakarta" = "Kota Jakarta Selatan", 
                                         "Central Jakarta" = "Kota Jakarta Pusat"),
                             selected = "DKI Jakarta"
                 ),
                 sliderInput("bandwidth",
                             "Select Bandwidth (in kilometres):",
                             min = 0.25,
                             max = 5,
                             value = 0.5,
                             step = 0.25),
                 selectInput("kernel",
                             "Select Kernel Method:",
                             choices = c("Gaussian" = "gaussian", 
                                         "Epanechnikov" = "epanechnikov", 
                                         "Quartic" = "quartic", 
                                         "Disc" = "disc"))
               ),
               mainPanel(
                 shinycssloaders::withSpinner(plotOutput("kdePlot"), type = 8, color = "#2caa4a")
               )
             )
    ),
    # Second tab with its own sidebar and main panel
    tabPanel("Variable Distribution",
             sidebarLayout(
               sidebarPanel(
                 # Inputs specific to Variable Distribution
                 # Define inputs here as done in the first tab
                 selectInput("var",
                             "Select Variable:",
                             choices = c("Monthly Price" = "price_monthly" 
                                         ),
                             selected = "price_monthly"
                )
               ),
               mainPanel(
                 # Output for the Variable Distribution plot
                 # Define plotOutput or other output here
                 shinycssloaders::withSpinner(plotOutput("varDistPlot"), type = 8, color = "#2caa4a")
                 
               )
             )
    ),
    # More tabs can be added here similarly
    # ...
    tabPanel("Correlation Plot",
             sidebarLayout(
               sidebarPanel(
                 helpText("A correlation plot shows the pairwise correlations between variables. 
                          It is useful for identifying relationships and potential trends in the data. 
                          Each cell in the plot shows the correlation coefficient between two variables, 
                          and the color and size of the cell may represent the strength and direction of the correlation.
                          In our app, we deem those above 0.7 to be highly correlated and thus redundant"),
               ),
               mainPanel(
                 # Output for the Variable Distribution plot
                 # Define plotOutput or other output here
                 shinycssloaders::withSpinner(plotOutput("corrPlot"), type = 8, color = "#2caa4a")
                 
               )
             )
    ),
    
    tabPanel("Data Table",
             sidebarLayout(
               sidebarPanel(
               #   # Inputs specific to Variable Distribution
               #   # Define inputs here as done in the first tab
                 numericInput("num",
                             "Select number of rows to show:",
                             10,
                             min=1,
                             max=200,
                             step=1,
                 )
               ),
               mainPanel(
                 # Output for the Variable Distribution plot
                 # Define plotOutput or other output here
                 shinycssloaders::withSpinner(tableOutput("dataTable"), type = 8, color = "#2caa4a")
                 
               )
             )
    ),
  )
)

# Define the server logic in another file if needed, or inline as part of the same script.
