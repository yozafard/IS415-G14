pacman::p_load(car, olsrr, corrplot, ggpubr, sf, spdep, GWmodel, tmap, tidyverse, gtsummary)

mlrd <- readRDS("gwr/data/mlr.rds")
jakarta_sf <- readRDS("gwr/data/jakarta_sf.rds")
mamikos_final <- read_rds("gwr/data/mamikos_final.rds")
mamikos_mlr <- mamikos_final |> 
  cbind(mlrd$fitted.values) |> 
  cbind(mlrd$residuals) |>
  cbind(mlrd$model$price_monthly) |>
  rename(`residuals` = `mlrd.residuals`, `fitted values` = `mlrd.fitted.values`, `actual values` = `mlrd.model.price_monthly`)

jakarta_mlr <-  jakarta_sf |>
  st_join(mamikos_mlr) |> 
  group_by(geometry, NAMOBJ) |> 
  summarise(across(where(is.numeric), ~mean(.x, na.rm = TRUE)),
            .groups = "drop")

mamikos_palette <- colorRampPalette(c("#f95516", "#dbdbdb", "#2caa4a"))(100)

# Server logic for GWR
output$GWRPlot <- renderTmap({
  plotted_coefficient <- input$gwr_coef
  
  bw <- input$bw
  bwc <- input$bwc
  dist <- input$dist
  kernel <- input$gwr_kernel
  
  # Load the processed GWR model
  fname <- paste0("gwr/data/jakarta_gwr/", bw, "_", bwc, "_", dist, "_", kernel, ".rds")
  jakarta_gwr <- readRDS(fname)
  
  # Use the reverse palette for the standard error
  paletteToUse <- if(plotted_coefficient == "size_SE") rev(mamikos_palette) else mamikos_palette
  
  tmap_mode("view")
  map <- tm_shape(jakarta_gwr) +
    tm_fill(col=input$gwr_coef,
            style="quantile",
            palette=paletteToUse,
            title=input$gwr_coef,
            midpoint = 0,
            popup.vars=c('size'='size')) +
    tm_borders() +
    tm_view(set.zoom.limits = c(11,14))  # Set zoom limits
  map
})

output$MLRDPlot <- renderTmap({
  
  plotted_coefficient <- input$mlr_coef
  # Use the reverse palette for the standard error
  paletteToUse <- if(plotted_coefficient == "size_SE") rev(mamikos_palette) else mamikos_palette
  
  tmap_mode("view")
  map <- tm_shape(jakarta_mlr) +
    tm_fill(col=input$mlr_coef,
            style="quantile",
            palette=paletteToUse,
            title=input$mlr_coef,
            midpoint = 0,
            popup.vars=c('size'='size')) +
    tm_borders() +
    tm_view(set.zoom.limits = c(11,14))  # Set zoom limits
  map
})