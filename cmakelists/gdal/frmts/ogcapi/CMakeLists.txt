add_gdal_driver(TARGET gdal_OGCAPI SOURCES gdalogcapidataset.cpp)
gdal_standard_includes(gdal_OGCAPI)
target_include_directories(gdal_OGCAPI PRIVATE ${GDAL_VECTOR_FORMAT_SOURCE_DIR}/gml)
