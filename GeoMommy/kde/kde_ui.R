library(shiny)
library(shinycssloaders)
coef_choices <- c("Price", "Price (Log Transformed)", "Gender", "Size", "Year of Construction", 
                  "Proximity to Airport", "Proximity to Church", 
                  "Proximity to Post Office", "Proximity to Health Facilities",
                  "Proximity to Mosque", "Proximity to Railway Station", 
                  "Proximity to Vihara", "Education Facilities Count within Range", 
                  "Pura Count within Range")
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
    tabPanel("Variable Distribution",
             sidebarLayout(
               sidebarPanel(
                 selectInput(
                   inputId = "var", 
                   label = "Select Variable:", 
                   choices = coef_choices,
                   selected = "Price"),
               ),
               mainPanel(
                 shinycssloaders::withSpinner(plotOutput("varDistPlot"), type = 8, color = "#2caa4a")
                 
               )
             )
    ),
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
                 helpText("
                         This is the Data Table
                         ")
               ),
               mainPanel(
                 # Output for the Variable Distribution plot
                 # Define plotOutput or other output here
                 shinycssloaders::withSpinner(DT::dataTableOutput("dataTable"), type = 8, color = "#2caa4a")
                 
               )
             )
    ),
  )
)

# Define the server logic in another file if needed, or inline as part of the same script.
