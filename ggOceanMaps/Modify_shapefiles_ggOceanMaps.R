setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
setwd('..')
setwd('..')

library(ggOceanMaps)

NEDPath <- paste0(getwd(),"/ggOceanMaps") # Natural Earth Data location
outPath <- paste0(getwd(),"/land") # Data output location

lims <- c(-6, 13, 50, 64)
projection <- "EPSG:3995"

#
# Norway shapefile
#
world <- rgdal::readOGR(paste(NEDPath, "NOR_adm/NOR_adm1.shp", sep = "/"))

bs_land <- clip_shapefile(world, lims)
bs_land <- sp::spTransform(bs_land, CRSobj = sp::CRS(projection))
rgeos::gIsValid(bs_land) # Has to return TRUE, if not use rgeos::gBuffer
#bs_land <- rgeos::gBuffer(bs_land, byid = TRUE, width = 0)
sp::plot(bs_land)

basemap(shapefiles = list(land = bs_land, 
                          glacier=ggOceanMapsData::arctic_glacier,
                          bathy = ggOceanMapsData::arctic_bathy),
        limits = c(4.8, 5.8, 60.5, 61),
        bathymetry = TRUE)

#
# ICES shapefile
#
world <- rgdal::readOGR(paste(NEDPath, "ices_areas/ices_areas.shp", sep = "/"))

bs_land <- clip_shapefile(world, lims)
bs_land <- sp::spTransform(bs_land, CRSobj = sp::CRS(projection))
rgeos::gIsValid(bs_land) # Has to return TRUE, if not use rgeos::gBuffer
bs_land <- rgeos::gBuffer(bs_land, byid = TRUE, width = 0)
sp::plot(bs_land)

basemap(shapefiles = list(land = bs_land, 
                          glacier=ggOceanMapsData::arctic_glacier,
                          bathy = ggOceanMapsData::arctic_bathy),
        limits = c(4.8, 5.8, 60.5, 61),
        bathymetry = TRUE,
        land.col = NA,
        fill = 'grey')


basemap(limits = c(4, 20, 57, 73), 
        bathymetry = TRUE, 
        bathy.style = "poly_greys",
        glaciers = TRUE, 
        gla.col = "cadetblue", # Change color of glaciers
        gla.border.col = NA, # Change color of border lines ('NA' remove lines)
        land.col = "#eeeac4", # Change color of land
        land.border.col = NA, # Change color of border lines
        #grid.col = NA, # Remove grid lines
        grid.size = 0.05)



## Change bathymetry data (Not relevant since we can load the data)

#etopoPath <- "C:/Users/floriane/OneDrive - Havforskningsinstituttet/Studium/R-Scripts/Maps/" 
#lims <- c(-6, 13, 50, 64)
#projection <- "+init=epsg:3995"
#basemap(limits = lims)
#rb <- raster_bathymetry(bathy = paste(etopoPath, "ETOPO1_Ice_g_gmt4.grd", sep = "/"),
#                        depths = c(100,200),
#                        proj.out = projection,
#                        boundary = lims)
#bs_bathy <- vector_bathymetry(rb)
#save(bs_bathy, file="Data/Map_data.Rdata")

load("Data/Map_data.Rdata")