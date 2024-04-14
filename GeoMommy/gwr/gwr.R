pacman::p_load(sf, dplyr, tmap, DT)

# d stands for descriptive
mlrd <- readRDS("gwr/data/mlr.rds")

mamikos_mlr <- readRDS("gwr/data/mamikos_final.rds") |> 
  mutate(`fitted values` = mlrd$fitted.values, 
         `residuals` = mlrd$residuals,
         `actual values` = mlrd$model$price_monthly)

jakarta_mlr <-  readRDS("gwr/data/jakarta_sf.rds") |>
  st_join(mamikos_mlr) |> 
  group_by(geometry, NAMOBJ) |> 
  summarise(across(where(is.numeric), ~mean(.x, na.rm = TRUE)),
            .groups = "drop")

mamikos_palette <- colorRampPalette(c("#f95516", "#dbdbdb", "#2caa4a"))(100)

# Rename the coefficients for the GWR model
coef_choices <- c("gender", "size", "building_year", "prox_airport", 
                  "prox_gereja", "prox_kantorpos", "prox_kesehatan", 
                  "prox_masjid", "prox_stasiunka", "prox_vihara", 
                  "pendidikan_within_med", "pura_within_med")

english_translations <- c("Gender", "Size", "Year of Construction", 
                          "Proximity to Airport", "Proximity to Church", 
                          "Proximity to Post Office", "Proximity to Health Facilities",
                          "Proximity to Mosque", "Proximity to Railway Station", 
                          "Proximity to Vihara", "Education Facilities Count within Range", 
                          "Pura Count within Range")

names(coef_choices) <- english_translations

# Server logic for GWR
output$GWRPlot <- renderTmap({
  plotted_coefficient <- coef_choices[input$gwr_coef]
  
  bw <- input$bw
  bwc <- input$bwc
  dist <- input$dist
  kernel <- input$gwr_kernel
  
  # Load the processed GWR model
  fname <- paste0("gwr/data/jakarta_gwr/", bw, "_", bwc, "_", dist, "_", kernel, ".rds")
  jakarta_gwr <- readRDS(fname)
  
  tmap_mode("view")
  
  map <- tm_shape(jakarta_gwr) +
    tm_fill(col=plotted_coefficient,
            style="quantile",
            palette=mamikos_palette,
            title=input$gwr_coef,
            midpoint = 0,
            popup.vars=c(plotted_coefficient)) +
    tm_borders() +
    tm_view(set.zoom.limits = c(11,14))  # Set zoom limits
  map
})

output$MLRDPlot <- renderTmap({
  
  plotted_coefficient <- input$mlr_coefs
  
  tmap_mode("view")
  map <- tm_shape(jakarta_mlr) +
    tm_fill(col=input$mlr_coef,
            style="quantile",
            palette=mamikos_palette,
            title=input$mlr_coef,
            midpoint = 0,
            popup.vars=c(plotted_coefficient)) +
    tm_borders() +
    tm_view(set.zoom.limits = c(11,14))  # Set zoom limits
  map
})

output$MLRDCoef <- renderDataTable({
  datatable(mlrd$coefficients |> as.data.frame(), 
            colnames = c("Variable", "Coefficient"),
            rownames = c("Intercept", english_translations),
            options = list(
              searching = FALSE,
              paging = FALSE,
              ordering = FALSE,
              info = FALSE
            ))
})