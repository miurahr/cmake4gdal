add_gdal_driver(TARGET gdal_OGCAPI SOURCES gdalogcapidataset.cpp)
gdal_standard_includes(gdal_OGCAPI)
target_include_directories(gdal_OGCAPI PRIVATE $<TARGET_PROPERTY:ogr_GML,SOURCE_DIR>)
