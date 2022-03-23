
#### Installation ####
#
# Install the package 'devtools' by using the 
# comment line below if you have not installed it 
#
#install.packages("devtools")

#
# Install the 'ggOceanMaps' package and the required 
# data package
#
devtools::install_github("MikkoVihtakari/ggOceanMapsData") # required by ggOceanMaps
devtools::install_github("MikkoVihtakari/ggOceanMaps")


#### Plotting a first map ####
#
# Open the package
#
library(ggOceanMaps)

#
# Create a data.frame with points to plot
#
dt <- data.frame(lon = c(-30, -30, 30, 30), lat = c(50, 80, 80, 50))

#
# Plot your first map
#
basemap(data = dt, # Use the data.frame we just create
        bathymetry = TRUE) + # Set 'bathymetry = TRUE' to add the bathymetry to your map
  geom_polygon(data = transform_coord(dt), aes(x = lon, y = lat), color = "red", fill = NA) # Plot a polygon

# You need to transform your data with transform_coord() but I will explain this on Monday!


