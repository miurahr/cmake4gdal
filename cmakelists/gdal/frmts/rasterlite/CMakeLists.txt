add_gdal_driver(TARGET gdal_Rasterlite SOURCES rasterlitedataset.h rasterlitecreatecopy.cpp rasterlitedataset.cpp
                                               rasterliteoverviews.cpp)
gdal_standard_includes(gdal_Rasterlite)
