pacman::p_load(sf, spdep, tmap, tidyverse, knitr, ggplot2, raster, spatstat, maptools, shiny, DT)

sf <- read_rds('./kde/data/mamikos_final.rds')
sf <- sf |> st_transform(23834)
jakarta <- read_rds('./kde/data/jakarta_sf.rds')
jakarta <- jakarta |> st_transform(23834)

# Define server logic required to draw a histogram
# output$kdePlot <- renderPlot({
# kde <- function(input, output, session) {
  # get_owin <- function(city_name) {
  #   if(city_name != "DKI Jakarta"){
  #     city <- jakarta[jakarta$WADMKK == city_name, ]
  #     owin <- as(as_Spatial(city), "owin")
  #   }
  #   else {
  #     owin <- as.owin(jakarta)
  #   }
  #   return(owin)
  # }
  # 
  # get_ppp <- function(city_name) {
  #   coords <- st_coordinates(sf)
  #   prices <- sf$price_monthly
  #   ppp_with_price <- spatstat.geom::ppp(coords[,1], coords[,2], marks=prices, window=get_owin(city_name))
  #   ppp_with_price <- rescale(ppp_with_price, 1000, "km")
  #   return(ppp_with_price)
  # }
  # 
  # get_kde <- function(city_name, bandwidth, kernel) {
  #   kde_500 <- density(get_ppp(city_name), sigma = bandwidth, edge=TRUE, kernel=kernel)
  #   return(kde_500)
  # }
  
  output$kdePlot <- renderPlot({
    get_owin <- function(city_name) {
      if(city_name != "DKI Jakarta"){
        city <- jakarta[jakarta$WADMKK == city_name, ]
        owin <- as(as_Spatial(city), "owin")
      }
      else {
        owin <- as.owin(jakarta)
      }
      return(owin)
    }
    
    get_ppp <- function(city_name) {
      coords <- st_coordinates(sf)
      prices <- sf$price_monthly
      ppp_with_price <- spatstat.geom::ppp(coords[,1], coords[,2], marks=prices, window=get_owin(city_name))
      ppp_with_price <- rescale(ppp_with_price, 1000, "km")
      return(ppp_with_price)
    }
    
    get_kde <- function(city_name, bandwidth, kernel) {
      kde_500 <- density(get_ppp(city_name), sigma = bandwidth, edge=TRUE, kernel=kernel)
      return(kde_500)
    }
    city_name <- input$city
    kde_est <- get_kde(city_name, input$bandwidth, input$kernel)
    # plot(kde_est, main=city_name)
    kde_grid <- as.SpatialGridDataFrame.im(kde_est)
    spplot(kde_grid, main=city_name)
    # plot(kde, main=city_name)
    # kde_raster <- raster(kde_grid)
    # projection(kde_raster) <- CRS("+init=EPSG:3414")
    # 
    # tm_shape(kde_raster) + 
    #   tm_raster("v") +
    #   tm_layout(legend.position = c("right", "bottom"), frame = FALSE)
  })
  
  output$varDistPlot <- renderPlot({
    # Retrieve the name of the variable to plot
    var_name <- input$var
    print(paste("Plotting variable:", var_name)) # For debugging
    
    # Create the plot
    ggplot(sf, aes_(x = as.name(var_name))) +
      geom_histogram(bins = 30, fill = "#2caa4a", color = "black") +
      labs(title = paste("Variable Distribution of", var_name),
           x = var_name,
           y = "Frequency")
  })
  
  mamikos_no_geo <- sf |> st_drop_geometry()
    
  output$corrPlot <- renderPlot({
    corrplot(cor(mamikos_no_geo |> dplyr::select(-c("x_id", "price_monthly"))),
           diag = FALSE, 
           order = "AOE",
           tl.pos = "td",
           tl.cex = 0.5, 
           method = "number", 
           type = "upper")
  })
  
  output$dataTable <- DT::renderDataTable({
    # Assuming `sf` is the data frame you want to display
    # You may want to remove geometry columns or other preprocessing
    DT::datatable(mamikos_no_geo, options = list(pageLength = input$num, scrollX = TRUE))
  })
