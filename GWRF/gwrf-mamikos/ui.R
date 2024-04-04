#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)

# Define UI for application that draws a histogram
fluidPage(

    # Application title
    titlePanel("Geographically Weighted Random Forest Prediction Model"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            selectInput(inputId = "region",
                        label = "Select Region",
                        choices = c("Jakarta Barat" = 'jakarta-barat', 
                                    "Jakarta Utara" = 'jakarta-utara', 
                                    "Jakarta Pusat" = 'jakarta-pusat', 
                                    "Jakarta Timur" = 'jakarta-timur', 
                                    "Jakarta Selatan" = 'jakarta-selatan'),
                        selected = "jakarta-barat"),
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
        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("distPlot")
        )
    )
)
