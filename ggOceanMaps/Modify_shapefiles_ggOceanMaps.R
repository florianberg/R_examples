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

# Downloaded at: https://www.diva-gis.org/gdata

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

# Downloaded at: https://gis.ices.dk/shapefiles/ICES_areas.zip

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
        land.col = NA)


#
# Vestland FGDB map
#

# Downloaded at: https://www.kartverket.no/api-og-data/kartgrunnlag-fastlands-norge

rgdal::ogrListLayers("Basisdata_46_Vestland_25832_N250Kartdata_FGDB.gdb")
world <- rgdal::readOGR("Basisdata_46_Vestland_25832_N250Kartdata_FGDB.gdb",
                        "N250_Høyde_omrade")

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