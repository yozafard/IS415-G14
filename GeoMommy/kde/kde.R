pacman::p_load(sp, sf, spdep, tmap, tidyverse, knitr, ggplot2, raster, spatstat, shiny, DT, knitr)

vars <- c("price_monthly", "log_price", "gender", "size", "building_year", "prox_airport", 
          "prox_gereja", "prox_kantorpos", "prox_kesehatan", 
          "prox_masjid", "prox_stasiunka", "prox_vihara", 
          "pendidikan_within_med", "pura_within_med")

english_translation <- c("Price", "Price (Log Transformed)", "Gender", "Size", "Year of Construction", 
                         "Proximity to Airport", "Proximity to Church", 
                         "Proximity to Post Office", "Proximity to Health Facilities",
                         "Proximity to Mosque", "Proximity to Railway Station", 
                         "Proximity to Vihara", "Education Facilities Count within Range", 
                         "Pura Count within Range")

sf <- read_rds('./kde/data/mamikos_final.rds') |> mutate(log_price = log(price_monthly)) 
sf <- dplyr::select(sf, c("geometry", vars))
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
    prices <- sf$price_monthly
    ppp_with_price <- spatstat.geom::ppp(coords[,1], coords[,2], marks=prices, window=get_owin(city_name))
    ppp_with_price <- rescale(ppp_with_price, 1000, "km")
    return(ppp_with_price)
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
  names(vars) <- english_translation
  var_name <- vars[input$var]
  
  # Plot based on the variable type
  if (!is.null(sf[[var_name]])) {  # Check if the column exists
    ggplot(sf, aes_string(x = var_name)) +
      geom_histogram(bins = 30, fill = "#2caa4a", color = "black") +
      labs(title = paste("Distribution of", var_name),
           x = var_name, 
           y = "Frequency")
  } else {
    stop("Selected variable does not exist in the dataset.")
  }
})



output$corrPlot <- renderPlot({
  df <- st_drop_geometry(sf)
  corrplot(cor(df |> dplyr::select(-c("x_id", "price_monthly"))),
           diag = FALSE, 
           order = "AOE",
           tl.pos = "td",
           tl.cex = 0.5, 
           method = "number", 
           type = "upper")
})

output$dataTable <- DT::renderDataTable({
  DT::datatable(sf, options = list(scrollX = TRUE))
})
