add_gdal_driver(TARGET ogr_OpenAir SOURCES ogr_openair.h ogropenairdatasource.cpp ogropenairdriver.cpp
                                           ogropenairlabellayer.cpp ogropenairlayer.cpp)
gdal_standard_includes(ogr_OpenAir)
