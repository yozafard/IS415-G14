pacman::p_load(car, olsrr, corrplot, ggpubr, sf, spdep, GWmodel, tmap, tidyverse, gtsummary)

mamikos_sf <- read_rds("gwr/data/mamikos_sf.rds")
mamikos_full <- read_rds("gwr/data/mamikos_full.rds")
bw <- read_rds("gwr/data/bw.rds")
gwr <- read_rds("gwr/data/gwr.rds")
jakarta_sf <- read_rds("gwr/data/jakarta_sf.rds")

mamikos_full <- mamikos_full |>
  mutate(log_price = log(price_monthly))
mamikos_sp <- as_Spatial(mamikos_full)
gwr_sf <- gwr$SDF |> st_as_sf() |> st_transform(crs = 4326)

mamikos_palette <- colorRampPalette(c("#f95516", "#dbdbdb", "#2caa4a"))(100)

# Server logic for GWR
output$GWRPlot <- renderTmap({
  selected_variable <- input$points
  # Use the reverse palette for the standard error
  paletteToUse <- if(selected_variable == "size_SE") rev(mamikos_palette) else mamikos_palette
  
  tmap_mode("view")
  map <- tm_shape(jakarta_sf) +
    tm_polygons() +
    tm_shape(gwr_sf) +
    tm_dots(col = selected_variable, 
            style = "quantile", 
            palette = paletteToUse,
            title = selected_variable,
            midpoint = 0) +
    tm_view(set.zoom.limits = c(11,14))
  map
})