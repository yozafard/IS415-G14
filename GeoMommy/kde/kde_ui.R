kde_ui <- tabPanel(
  "KDE",
  titlePanel("KDE"),
  
  sidebarLayout(
    sidebarPanel(
      textInput("text1", "KDE Text Input:", "Sample text for KDE")
    ),
    mainPanel(
      textOutput("KDEOutput")
    )
  )
)