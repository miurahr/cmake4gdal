add_gdal_driver(TARGET ogr_SEGY SOURCES ogr_segy.h ogrsegydatasource.cpp ogrsegydriver.cpp ogrsegylayer.cpp)
gdal_standard_includes(ogr_SEGY)
