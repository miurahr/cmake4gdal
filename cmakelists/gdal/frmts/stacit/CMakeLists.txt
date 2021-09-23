add_gdal_driver(TARGET gdal_STACIT SOURCES stacitdataset.cpp)
gdal_standard_includes(gdal_STACIT)
target_include_directories(gdal_STACIT PRIVATE $<TARGET_PROPERTY:gdal_vrt,SOURCE_DIR>)
