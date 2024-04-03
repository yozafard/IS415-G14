# Server logic for Feature 1
output$KDEOutput <- renderText({
  paste("Feature 1 input:", input$text1)
})