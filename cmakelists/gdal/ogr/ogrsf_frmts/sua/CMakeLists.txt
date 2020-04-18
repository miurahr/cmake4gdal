add_gdal_driver(TARGET ogr_SUA SOURCES ogr_sua.h ogrsuadatasource.cpp ogrsuadriver.cpp ogrsualayer.cpp)
gdal_standard_includes(ogr_SUA)
