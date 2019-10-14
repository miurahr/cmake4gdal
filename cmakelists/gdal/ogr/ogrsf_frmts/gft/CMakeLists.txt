add_gdal_driver(TARGET ogr_GFT SOURCES ogr_gft.h ogrgftdatasource.cpp ogrgftdriver.cpp ogrgftlayer.cpp
                ogrgftresultlayer.cpp ogrgfttablelayer.cpp)
gdal_standard_includes(ogr_GFT)
