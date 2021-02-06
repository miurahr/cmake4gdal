add_gdal_driver(TARGET gdal_STACTA SOURCES stactadataset.cpp)
gdal_standard_includes(gdal_STACTA)
target_include_directories(gdal_STACTA PRIVATE $<TARGET_PROPERTY:gdal_MEM,SOURCE_DIR>)
