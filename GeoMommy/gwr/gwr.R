library(ggplot2)

# Server logic for Feature 2
output$GWRPlot <- renderPlot({
  data <- data.frame(x = 1:input$numgwr, y = rnorm(input$numgwr))
  ggplot(data, aes(x = x, y = y)) +
    geom_line() + geom_point() +
    ggtitle("Feature 2 Plot")
})