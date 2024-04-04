pacman::p_load(car, olsrr, corrplot, ggpubr, sf, spdep, GWmodel, tmap, tidyverse, gtsummary)

jakarta_gwr <- read_rds("gwr/data/jakarta_gwr.rds")
mamikos_palette <- colorRampPalette(c("#f95516", "#dbdbdb", "#2caa4a"))(100)

# Server logic for GWR
output$GWRPlot <- renderTmap({
  plotted_coefficient <- input$coef
  # Use the reverse palette for the standard error
  paletteToUse <- if(plotted_coefficient == "size_SE") rev(mamikos_palette) else mamikos_palette
  
  tmap_mode("view")
  map <- tm_shape(jakarta_gwr) +  # Your spatial polygons data
    tm_polygons(col=input$coef,  # The variable to color by
                style="quantile",  # The method for creating color breaks
                palette=mamikos_palette,  # Your chosen color palette
                title=input$coef) +  # Legend title
    tm_view(set.zoom.limits = c(11,14))  # Set zoom limits
  map
})