add_gdal_driver(TARGET gdal_RDB SOURCES rdbdataset.cpp)
gdal_standard_includes(gdal_RDB)
target_include_directories(gdal_RDB PRIVATE $<TARGET_PROPERTY:ogr_geojson,SOURCE_DIR>)
