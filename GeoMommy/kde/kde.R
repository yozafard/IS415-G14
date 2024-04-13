pacman::p_load(sp, sf, spdep, tmap, tidyverse, knitr, ggplot2, raster, spatstat, shiny, DT, knitr)
sf <- read_rds('./kde/data/mamikos_final.rds')
sf <- sf |> st_transform(23834)
jakarta <- read_rds('./kde/data/jakarta_sf.rds')
jakarta <- jakarta |> st_transform(23834)
  
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

    get_ppp <- function(city_name, kde_type) {
      coords <- st_coordinates(sf)
      if(kde_type == "with_price") {
        prices <- sf$price_monthly
        ppp_with_price <- spatstat.geom::ppp(coords[,1], coords[,2], marks=prices, window=get_owin(city_name))
        ppp_with_price <- rescale(ppp_with_price, 1000, "km")
        return(ppp_with_price)
      } else {
        ppp_without_price <- spatstat.geom::ppp(coords[,1], coords[,2], window=get_owin(city_name))
        ppp_without_price <- rescale(ppp_without_price, 1000, "km")
        return(ppp_without_price)
      }
    }

    get_kde <- function(city_name, kde_type, bandwidth, kernel) {
      kde_500 <- density(get_ppp(city_name, kde_type), sigma = bandwidth, edge=TRUE, kernel=kernel)
      return(kde_500)
    }
    city_name <- input$city
    kde_type <- input$kde_type
    kde_est <- get_kde(city_name, kde_type, input$bandwidth, input$kernel)
    plot(kde_est, main=city_name)
  })
  
  
  
  output$varDistPlot <- renderPlot({
    # Retrieve the name of the variable to plot
    var_name <- input$var
    if (input$var == "log_price") {
      sf <- sf |>
        mutate(log_price = log(price_monthly))
    }
    print(paste("Plotting variable:", var_name)) # For debugging
    
    # Create the plot
    ggplot(sf, aes_(x = as.name(var_name))) +
      geom_histogram(bins = 30, fill = "#2caa4a", color = "black") +
      labs(title = paste("Variable Distribution of", var_name),
           x = var_name,
           y = "Frequency")
  })
  
  # mamikos_no_geo <- sf |> st_drop_geometry()
    
  output$corrPlot <- renderPlot({
    mamikos_no_geo <- sf |> st_drop_geometry()
    corrplot(cor(mamikos_no_geo |> dplyr::select(-c("x_id", "price_monthly"))),
           diag = FALSE, 
           order = "AOE",
           tl.pos = "td",
           tl.cex = 0.5, 
           method = "number", 
           type = "upper")
  })
  
  output$dataTable <- DT::renderDataTable({
    # mamikos_no_geo <- sf |> st_drop_geometry()
    # Assuming `sf` is the data frame you want to display
    # You may want to remove geometry columns or other preprocessing
    print(sf)
    DT::datatable(sf, options = list(pageLength = input$num, scrollX = TRUE))
  })
