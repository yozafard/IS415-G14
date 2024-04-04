library(ggplot2)

gwRF <- readRDS("gwrf/data/gwRF_adaptive.rds")
grf_pred <- readRDS("gwrf/data/GRF_pred.rds")
test_data <- readRDS("gwrf/data/test_data_p.rds")

airport <- readRDS("gwrf/data/airport.rds")
gereja <- readRDS("gwrf/data/gereja.rds")
kantorpos <- readRDS("gwrf/data/kantorpos.rds")
kesehatan <- readRDS("gwrf/data/kesehatan.rds")
masjid <- readRDS("gwrf/data/masjid.rds")
other_saranaibadah <- readRDS("gwrf/data/other_saranaibadah.rds")
pendidikan <- readRDS("gwrf/data/pendidikan.rds")
pura <- readRDS("gwrf/data/pura.rds")
stasiunka <- readRDS("gwrf/data/stasiunka.rds")
vihara <- readRDS("gwrf/data/vihara.rds")
jakarta_union <- readRDS("gwrf/data/jakarta_union.rds")

addr_input <- reactive({
  data.frame(addr = input$searchBar)
})

coord <- reactive({
  if (is.null(input$searchBar) || input$searchBar == "" || is.null(addr_input$lat)) {
    return(data.frame(addr = "Jakarta", lat = 106.8387, long = -6.208745, zoom = 11))
  } else {
    # Perform geocoding
    geocode(addr_input(), address = "addr", method = "osm") |> mutate(zoom = 15)
  }
})

searchResults <- reactive({
  if (is.null(input$searchBar) || input$searchBar == "" || is.null(addr_input$lat)){
    searchBar = "Jakarta"
  } else {
    searchBar = input$searchBar
  }
  searchedLocations <- coord()[grepl(pattern = input$searchBar, x = coord()$addr, ignore.case = TRUE),]
  return(searchedLocations)
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

output$GWRFPlot <- renderPlot({
  ggplot(data = test_data,
         aes(x = grf_pred,
             y = price_monthly)) +
    geom_point()
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

output$GWRFText <- renderText({
  paste("Predicted Price:")data
})


# addr_input <- data.frame(addr = input$searchBar)
# coord <- geocode(addr_input, address = addr, method = "osm")
# 
# # Server logic for Feature 
# output$GWRFPlot <- renderPlot({
#   ggplot(data = test_data,
#          aes(x = GRF_pred,
#              y = price_monthly)) +
#     geom_point()
# 
# 
# })
# 
# searchResults <- reactive({
#   # Assuming 'locations' is a data frame with your locations and their coordinates
#   searchedLocations <- coord[grepl(pattern = input$searchBar, x = coord$addr, ignore.case = TRUE), ]
#   return(searchedLocations)
# })
# 
# # Update the map based on search results
# observe({
#   # Using leafletProxy to update the map reactively
#   leafletProxy("GWRFMap", data = searchResults()) %>%
#     clearMarkers() %>%  # Clear existing markers
#     addMarkers(~long, ~lat)  # Add new markers based on search results
# })

