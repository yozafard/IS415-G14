library(ggplot2)

# Server logic for Feature 
output$GWRFPlot <- renderPlot({
  data <- data.frame(x = 1:input$numgwrf, y = rnorm(input$numgwrf))
  ggplot(data, aes(x = x, y = y)) +
    geom_line() + geom_point() +
    ggtitle("Feature 3 Plot")
})