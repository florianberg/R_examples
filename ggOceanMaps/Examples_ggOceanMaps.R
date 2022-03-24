setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(ggOceanMaps)


#### Define limits of the map ####

# It is recommended to use decimal degree coordinates
# when using the limits argument.
# The limits argument can consist of either a single number
# when plotting the poles and defines the most southern latitude:

basemap(limits = 60)

# Or most northern latitude:

basemap(limits = -60)

# In most cases you will need to plot rectangular maps and
# you have to use a vector of length.
# c(Start_lon, End_lon, Start_lat, End_lat)

#
# Plot Norway
#
basemap(limits = c(4, 20, 57, 73))

#
# Plot North Sea
#
basemap(limits = c(-4, 8, 49, 62))

#
# Plot Masfjorden
#
basemap(limits = c(4.8, 5.5, 60.5, 61))

# We will come back later to change the resolution


#### Data limits of maps ####
#
# Instead of defining the limits manually,
# the data you want to plot can be used directly.
# Your data need to have column names for 
# longitude (such as “lon”, “long”, or “longitude”) 
# and latitude (“lat”, “latitude”) columns

dt <- data.frame(lon = c(5, 5, -5, -5), lat = c(49, 62, 62, 49))

basemap(data = dt) +
  geom_spatial_polygon(data = dt, aes(x = lon, y = lat), fill = NA, color = "red", size=2)

# Be aware the we have to use geom_spatial_ in this case


#### Adding data to maps ####
dt <- data.frame(lon = c(5, 5, 5, 0, 0, 0), lat = c(52, 56, 60, 52, 56, 60))

#
# Plot the data with geom_spatial functions
#
basemap(limits = c(-4, 8, 49, 62))+
  geom_spatial_point(data = dt, aes(x = lon, y = lat), color = "blue")

#
# Plot the data with ggplot (geom_) functions
#
basemap(shapefiles = "ArcticStereographic")+
  geom_point(data = dt, aes(x = lon, y = lat), color = "blue")

#
# Plot the data with ggplot (geom_) functions
# and transformation of data
#
basemap(limits = c(-4, 8, 49, 62))+
  geom_point(data = transform_coord(dt), aes(x = lon, y = lat), color = "blue")


#### Transformation of data ####

#
# Plot map with decimal degrees
#
basemap(limits = c(-20, 20, 40, 70))

#
# Plot map with UTM coordinates on projection
#
basemap(limits = c(-20, 20, 40, 70), projection.grid = TRUE, grid.col = "red")

#
# Transform data
#
transform_coord(dt)
transform_coord(dt, verbose = TRUE)
transform_coord(dt, bind = TRUE, verbose = TRUE)
transform_coord(dt, # Define dataset with lon/lat coordinates
                new.names = c("X.utm", "Y.utm"), # Define names for transformed coordinates
                bind = TRUE, # Print information about which projections being used
                verbose = TRUE) # Add new transformed coordinates to data.frame

dt_trans <- transform_coord(dt, new.names = c("X.utm", "Y.utm"), bind = TRUE, verbose = TRUE)

basemap(shapefiles = "ArcticStereographic")+
  geom_point(data = dt_trans, aes(x = X.utm, y = Y.utm), color = "blue")

basemap(limits = c(-4, 8, 49, 62))+
  geom_point(data = dt_trans, aes(x = X.utm, y = Y.utm), color = "blue")

#### Adding bathymetry and glaciers ####

basemap(limits = 60) # Plot map
basemap(limits = 60, bathymetry = TRUE) # Add bathymetry
basemap(limits = 60, bathymetry = TRUE, glaciers = TRUE) # Add glaciers

#
# Bathymetry styles
#
basemap(limits = c(0, 46, 70, 81), bathymetry = TRUE, 
        bathy.style = "poly_greys") # Grey filled polygons
basemap(limits = c(0, 46, 70, 81), bathymetry = TRUE, 
        bathy.style = "contour_blues") # Colored contour lines
basemap(limits = c(0, 46, 70, 81), bathymetry = TRUE, 
        bathy.style = "contour_grey") # Grey contour lines

#
# Customizing bathymetry styles
#

# The bathy.style = "poly_*" bathymetry polygons are mapped to 
# geom_fill_discrete and can be modifying using standard ggplot syntax
basemap(limits = c(0, 46, 70, 81), bathymetry = TRUE) + 
  scale_fill_viridis_d("Water depth (m)")

# And the bathy.style = "contour_*" bathymetry lines 
# are mapped to geom_color_discrete 
basemap(limits = c(0, 46, 70, 81), bathymetry = TRUE, bathy.style = "contour_blues") + 
  scale_color_hue()

#
# Remove legend for bathymetry
#
basemap(limits = c(0, 46, 70, 81), bathymetry = TRUE,
        legends = FALSE) 


#### Detailed maps ####

#
# Using different shapefiles
#

shapefile_list("all")

basemap(shapefiles = "ArcticStereographic")
basemap(shapefiles = "AntarcticStereographic")
basemap(shapefiles = "DecimalDegree")
basemap(shapefiles = "Svalbard")
basemap(shapefiles = "BarentsSea")
#basemap(shapefiles = "IBCAO", bathymetry = TRUE) #Takes lot of memory to plot


#### Advanced use ####

# 
# Modify the layout and graphical parameters 
#
basemap(limits = c(4, 20, 57, 73), 
        bathymetry = TRUE, 
        bathy.style = "poly_greys",
        glaciers = TRUE, 
        gla.col = "cadetblue", # Change color of glaciers
        gla.border.col = NA, # Change color of border lines ('NA' remove lines)
        land.col = "#eeeac4", # Change color of land
        land.border.col = NA, # Change color of border lines
        #grid.col = NA, # Remove grid lines
        grid.size = 0.05) # Change size of grid lines

#
# Add scale bar and north arrow
#
# Scale bar and north arrows can be added using the ggspatial functions
basemap(limits = c(4, 20, 57, 73)) +
  annotation_scale(location = "br") + # Add scale at br = bottom right
  annotation_north_arrow(location = "tl", which_north = "true") # Add arrow at tl = topleft

#
# Reorder layers
#

data(fishingAreasNor, package = "ggOceanMapsData")

p <- basemap(limits = raster::extent(fishingAreasNor)[1:4],
             grid.col = NA) + 
  annotation_spatial(fishingAreasNor, fill = "red") 

p

#
# Move basemap land, glacier and grid layers on top of other ggplot layers
#
reorder_layers(p)


