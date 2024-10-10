library(sf)
library(spdep)
library(ggplot2)
library(tmap)


data <- st_read("sample_point_data.gpkg")
summary(data)

cleaned_data <- na.omit(data)
summary(cleaned_data)

tmap_mode("view")
tm_shape(cleaned_data) +
  tm_dots(
    col = "#3182bd",
    border.col = NA,
    size = 0.1
  )


##### Univariate Analyis #####
# Analyze the distribution of a single variable
summary(cleaned_data$height)

ggplot(cleaned_data, aes(x = height)) +
  geom_histogram(
    binwidth = 1,
    fill = "#fa9fb5",
    color = "#c51b8a",
    alpha = 0.5
  ) +
  labs(
    title = "Histogram",
    x = "height",
    y = "frequency"
  ) +
  theme_minimal()

ggplot(cleaned_data, aes(x = as.factor(nuts_1), y = height)) +
  geom_boxplot(
    fill = "#fa9fb5",
    color = "#c51b8a",
    alpha = 0.5
  ) +
  labs(
    title = "Boxplot",
    y = "height"
  ) +
  theme_minimal()


##### Bivariate Analyis #####
# Analyze the correlation between two variables
correlation_coefficient <- cor(cleaned_data$height, cleaned_data$perimeter)

ggplot(cleaned_data, aes(x = perimeter, y = height)) +
  geom_point(
    alpha = 0.5,
    color = "#e66101"
  ) +
  geom_smooth(
    method = "lm",
    se = FALSE,
    color = "#5e3c99"
  ) +
  annotate("text",
    x = max(cleaned_data$perimeter) * 0.7,
    y = max(cleaned_data$height) * 0.7,
    label = paste("correlation: ", round(correlation_coefficient, 3)),
    color = "black", size = 5
  ) +
  labs(
    title = "Scatterplot",
    x = "perimeter",
    y = "height"
  ) +
  theme_minimal()


##### Preprocessing for Global/Local Spatial Autocorrelation Analysis #####
# Create the spatial weights matrix
coords <- st_coordinates(cleaned_data)
nb <- knn2nb(knearneigh(coords, k = 10))
lw <- nb2listw(nb, style = "W")


##### Global Spatial Autocorrelation Analyis #####
# Calculate and visualize the (Univariate) Global Moran's I
global_moran_height <- moran.test(cleaned_data$height, lw)
print(global_moran_height)

moran.plot(cleaned_data$height, lw, main = "Global Moran's I")


##### Local Spatial Autocorrelation Analyis #####
# Calculate and visualize the (Univariate) Local Moran's I
local_moran_height <- localmoran(cleaned_data$height, lw)
cleaned_data$local_moran_height <- local_moran_height[, 4]
cleaned_data$p_value_height <- local_moran_height[, 5]
summary(cleaned_data$local_moran_height)

tmap_mode("view")
tm_shape(cleaned_data) +
  tm_dots(
    col = "local_moran_height",
    palette = "viridis",
    title = "LISA Z-scores",
    style = "cont",
    size = 0.1
  ) +
  tm_layout(
    legend.position = c("right", "top")
  )

cleaned_data$cluster_height <- "NS"
cleaned_data$cluster_height[
  cleaned_data$local_moran_height > 0 &
    cleaned_data$height > mean(cleaned_data$height) &
    cleaned_data$p_value_height <= 0.05
] <- "High-High"
cleaned_data$cluster_height[
  cleaned_data$local_moran_height > 0 &
    cleaned_data$height < mean(cleaned_data$height) &
    cleaned_data$p_value_height <= 0.05
] <- "High-Low"
cleaned_data$cluster_height[
  cleaned_data$local_moran_height < 0 &
    cleaned_data$height > mean(cleaned_data$height) &
    cleaned_data$p_value_height <= 0.05
] <- "Low-High"
cleaned_data$cluster_height[
  cleaned_data$local_moran_height < 0 &
    cleaned_data$height < mean(cleaned_data$height) &
    cleaned_data$p_value_height <= 0.05
] <- "Low-Low"
cleaned_data$cluster_height <- factor(
  cleaned_data$cluster_height,
  levels = c(
    "High-High",
    "High-Low",
    "Low-High",
    "Low-Low",
    "NS"
  )
)

tmap_mode("view")
tm_shape(cleaned_data) +
  tm_dots(
    col = "cluster_height",
    palette = c("#ca0020", "#f4a582", "#92c5de", "#0571b0", "gray"),
    title = "LISA clusters",
    size = 0.1
  ) +
  tm_layout(
    legend.position = c("right", "top")
  )
