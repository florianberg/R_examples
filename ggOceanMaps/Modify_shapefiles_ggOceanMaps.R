setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(ggOceanMaps)

#
# Define parameters
#
NEDPath <- paste0(getwd(),"/Shapefiles") # Locate folder with shapefiles
lims <- c(-6, 13, 50, 64) # Define limits for the map
projection <- "EPSG:3995" # Define a projection


#### Customize land shapefiles ####

#
# Norway land shapefile
#

# Downloaded at: https://www.diva-gis.org/gdata

#
# Prepare the data
#
world <- rgdal::readOGR(paste(NEDPath, "NOR_adm/NOR_adm1.shp", sep = "/")) # Read in shapefile

bs_land <- clip_shapefile(world, lims) # Limit shapefile to needed region
bs_land <- sp::spTransform(bs_land, CRSobj = sp::CRS(projection)) # Transform shapefile to projection
rgeos::gIsValid(bs_land) # Has to return TRUE, if not use rgeos::gBuffer see below
#bs_land <- rgeos::gBuffer(bs_land, byid = TRUE, width = 0)
sp::plot(bs_land) # Plots the customized shapefile

#
# Plot the map with basemap()
#

# You now need to define which shapefile should be used
# by shapefiles = list(land = XXX, glacier = XXX, bathy = XXX
# Where you replace the XXX by the customized shapefiles

basemap(shapefiles = list(land = bs_land, 
                          glacier = ggOceanMapsData::arctic_glacier,
                          bathy = ggOceanMapsData::arctic_bathy),
        limits = c(4.8, 5.8, 60.5, 61),
        bathymetry = TRUE)

#
# ICES shapefile
#

# Downloaded at: https://gis.ices.dk/shapefiles/ICES_areas.zip

world <- rgdal::readOGR(paste(NEDPath, "ices_areas/ices_areas.shp", sep = "/"))

bs_land <- clip_shapefile(world, lims)
bs_land <- sp::spTransform(bs_land, CRSobj = sp::CRS(projection))
rgeos::gIsValid(bs_land) # Has to return TRUE, if not use rgeos::gBuffer
#bs_land <- rgeos::gBuffer(bs_land, byid = TRUE, width = 0)
sp::plot(bs_land)

basemap(shapefiles = list(land = bs_land, 
                          glacier = ggOceanMapsData::arctic_glacier,
                          bathy = ggOceanMapsData::arctic_bathy),
        limits = c(4.8, 5.8, 60.5, 61),
        bathymetry = TRUE,
        land.col = NA) # Set land.col = NA becuase the polygons are swaped 


#
# Vestland land FGDB map
#

# Downloaded at: https://www.kartverket.no/api-og-data/kartgrunnlag-fastlands-norge

rgdal::ogrListLayers("Shapefiles/Basisdata_46_Vestland_25832_N250Kartdata_FGDB.gdb")
world <- rgdal::readOGR("Shapefiles/Basisdata_46_Vestland_25832_N250Kartdata_FGDB.gdb",
                        "N250_Høyde_omrade")

bs_land <- clip_shapefile(world, lims)
bs_land <- sp::spTransform(bs_land, CRSobj = sp::CRS(projection))
rgeos::gIsValid(bs_land) # Has to return TRUE, if not use rgeos::gBuffer
#bs_land <- rgeos::gBuffer(bs_land, byid = TRUE, width = 0)
sp::plot(bs_land)

basemap(shapefiles = list(land = bs_land, 
                          glacier = ggOceanMapsData::arctic_glacier,
                          bathy = ggOceanMapsData::arctic_bathy),
        limits = c(4.8, 5.8, 60.5, 61),
        bathymetry = TRUE)

# It is recommended to save the customized land shapefiles
# so that you do not need to re-run and prepare it everytime

save(bs_land, file = "Shapefiles/New_land_shapefile.Rdata")


#### Customize bathymetry files ####

#
# GEBCO bathymetry grid
#

# Downloaded at: https://download.gebco.net/ in "2D netCDF" format

rb <- raster_bathymetry(bathy = paste(NEDPath, "GEBCO/gebco_2021.nc", sep = "/"),
                        depths = c(100,200),
                        proj.out = projection,
                        boundary = lims)
bs_bathy <- vector_bathymetry(rb)

save(bs_bathy, file = "Shapefiles/New_bathymetry_shapefile.Rdata")


basemap(shapefiles = list(land = ggOceanMapsData::arctic_land, 
                          glacier = ggOceanMapsData::arctic_glacier,
                          bathy = bs_bathy),
        limits = c(-4, 13, 49, 64),
        bathymetry = TRUE)

basemap(shapefiles = list(land = bs_land, 
                          glacier = ggOceanMapsData::arctic_glacier,
                          bathy = bs_bathy),
        limits = c(4.8, 5.8, 60.5, 61),
        bathymetry = TRUE)
