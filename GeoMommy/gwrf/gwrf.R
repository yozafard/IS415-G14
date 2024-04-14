library(ggplot2, sf, tidyverse)

gwRF <- readRDS("gwrf/data/model/GWRF_model_10%_100trees.rds")
# grf_pred <- readRDS("gwrf/data/GRF_pred.rds")
test_data <- readRDS("gwrf/data/test2.rds")

airport <- readRDS("gwrf/data/airport.rds")
gereja <- readRDS("gwrf/data/gereja.rds")
kantorpos <- readRDS("gwrf/data/kantorpos.rds")
kesehatan <- readRDS("gwrf/data/kesehatan.rds")
masjid <- readRDS("gwrf/data/masjid.rds")
# other_saranaibadah <- readRDS("gwrf/data/other_saranaibadah.rds")
pendidikan <- readRDS("gwrf/data/pendidikan.rds")
pura <- readRDS("gwrf/data/pura.rds")
stasiunka <- readRDS("gwrf/data/stasiunka.rds")
vihara <- readRDS("gwrf/data/vihara.rds")
jakarta_union <- readRDS("gwrf/data/jakarta_union.rds")
poi <- readRDS("gwrf/data/poi.rds")
pendidikan_med <- readRDS("gwrf/data/pendidikan_med.rds")
pura_med <- readRDS("gwrf/data/pura_med.rds")
mlr <- readRDS("gwrf/data/model/mlr.rds")
mlr_test <- readRDS("gwrf/data/mlr_test.rds")

observeEvent(input$predict, {
addr_input <- reactive({
  if (is.null(input$searchBar) || input$searchBar == ""){
    return(data.frame(addr = "Jakarta"))
  } else {
    return(data.frame(addr = input$searchBar))
  }
})

coord <- reactive({
  if (is.null(input$searchBar) || input$searchBar == "" || is.null(addr_input()$addr)) {
    return(data.frame(addr = "Jakarta", lat = 106.8387, long = -6.208745, zoom = 11))
  } else {
    # Perform geocoding
    geocode(addr_input(), address = "addr", method = "osm") |> mutate(zoom = 15)
  }
})

searchResults <- reactive({
  if (is.null(input$searchBar) || input$searchBar == "" || is.null(addr_input()$addr)){
    searchBar = "Jakarta"
  } else {
    searchBar = input$searchBar
  }
  searchedLocations <- coord()[grepl(pattern = input$searchBar, x = coord()$addr, ignore.case = TRUE),]
  return(searchedLocations)
})


result <- reactive ({
  input_user <- reactive({
  if (is.null(input$searchBar) || input$searchBar == "" || is.null(addr_input$lat)){
  data.frame(addr = "Jakarta", lat = searchResults()$lat, long = searchResults()$long, gender = input$gender, building_year = input$building_year, size = input$size)
  } else {
    data.frame(addr = input$searchBar, lat = searchResults()$lat, long = searchResults()$long, gender = input$gender, building_year = input$building_year, size = input$size)
}
    })

input_sf <- st_as_sf(searchResults(), coords = c("long", "lat"), crs = 4326)
poi <- poi |> filter(REMARK %in% c("AIRPORT", "Gereja", "Vihara", "Pura", "KESEHATAN", "Masjid", "KANTORPOS", "PENDIDIKAN", "STASIUNKA"))
distance <- st_distance(input_sf, poi)
distance <- as.numeric(distance)
distance <- data.frame(distance)
distance_pair <- distance |> mutate(POI = poi$REMARK)

distance_min_prox <- distance_pair |> 
  group_by(POI) |> 
  summarise(min_distance = min(distance)) |>
  pivot_wider(names_from = POI, values_from = min_distance)

distance_within <- distance_pair |>
  summarise(pendidikan_within_med = sum(POI == "PENDIDIKAN" & distance <= pendidikan_med),
            pura_within_med = sum(POI == "Pura" & distance <= pura_med))

input_full <- cbind(input_sf, distance_min_prox) |> cbind(distance_within) |> dplyr::select(-c("PENDIDIKAN", "Pura"))

input_full <- rename(input_full, "PROX_AIRPORT" = "AIRPORT", "PROX_STASIUNKA" = "STASIUNKA", "PROX_KESEHATAN" = "KESEHATAN", "PROX_KANTORPOS" = "KANTORPOS", "PROX_MASJID" = "Masjid", "PURA_WITHIN_MED" = "pura_within_med", "PENDIDIKAN_WITHIN_MED" = "pendidikan_within_med", "PROX_GEREJA" = "Gereja", "PROX_VIHARA" = "Vihara")
names(input_full) <- tolower(names(input_full))

input_coor <- st_coordinates(input_sf)

input_data <- cbind(input_full, input_coor) |>
  st_drop_geometry() |> dplyr::select(-c(addr)) |> mutate(size = as.numeric(input$size), gender = as.numeric(input$gender), building_year = as.numeric(input$building_year))

if (input$model == "Geographically Weighted Random Forest") {
  gwRF_pred <- predict.grf(gwRF, 
                           input_data, 
                           x.var.name="X",
                           y.var.name="Y", 
                           local.w=1,
                           global.w=0) |> as.data.frame()
  
  return(gwRF_pred)
} else {
  input_data <- input_data |> dplyr::select(-c("X", "Y"))
  return(predict(mlr, input_data))
}
})


# Update the map based on search results
observe({
  # Get the search results
  searchRes <- searchResults()
  
  if(nrow(searchRes) > 0) {
    leafletProxy("GWRFMap", data = searchRes) %>%
      clearMarkers() %>%
      addMarkers(~long, ~lat) 
    # flyTo(~long, ~lat, zoom = ~zoom)
  }
})

output$GWRFText <- renderText({
  
  paste("Predicted Price:")
  
  if (is.null(input$searchBar) || input$searchBar == "" || is.null(addr_input()$addr)){
    paste("Predicted Price: Please input the rental unit data")
  } else {
    paste("Predicted Price: Rp.", round(result(),2))
  }
})

})

output$ModelText <- renderText({
  
  paste("Predicted Price:")
  
  if (input$model == "Geographically Weighted Random Forest") {
    paste(input$model, "MAPE:", MAPE(test_data$price_monthly, test_data$gwRF_pred))
  } else {
    paste(input$model, "MAPE:", MAPE(mlr_test$price_monthly, mlr_test$mlr_pred))
  }
  
  
})

output$GWRFPlot <- renderPlot({
  if (input$model == "Geographically Weighted Random Forest") {
    ggplot(data = test_data,
           aes(x = gwRF_pred,
               y = price_monthly)) +
      geom_point()
  } else {
    ggplot(data = mlr_test,
           aes(x = mlr_pred,
               y = price_monthly)) +
      geom_point()
  }
})


output$GWRFMap <- renderLeaflet({
  leaflet() %>%
    addTiles() %>%
    setView(lng = 106.8387, lat = -6.208745, zoom = 11) %>%
    addPolygons(data = jakarta_union,
                color = "red",
                fillColor = "yellow",
                weight = 2)
}
)



