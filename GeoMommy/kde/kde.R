pacman::p_load(sf, spdep, tmap, tidyverse, knitr, ggplot2, raster, spatstat, maptools, shiny)

sf <- read_rds('./kde/data/mamikos_full.rds')
sf <- sf |> st_transform(23834)
jakarta <- read_rds('./kde/data/jakarta_sf.rds')
jakarta <- jakarta |> st_transform(23834)

# Define server logic required to draw a histogram
# output$kdePlot <- renderPlot({
# kde <- function(input, output, session) {
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
  
  output$kdePlot <- renderPlot({
    city_name <- input$city
    kde_est <- get_kde(city_name, input$bandwidth, input$kernel)
    plot(kde_est, main=city_name)
    # kde_grid <- as.SpatialGridDataFrame.im(kde)
    # spplot(kde_grid, main=city_name)
    # plot(kde, main=city_name)
    # ggplot(kde, aes(x = x, y = y, fill = z)) +
    #   geom_raster(interpolate = TRUE) +
    #   scale_fill_viridis_c() +
    #   coord_fixed() +
    #   labs(fill = "Density", x = "Longitude", y = "Latitude") +
    #   theme_minimal() +
    #   theme(legend.position = "right")
  })

