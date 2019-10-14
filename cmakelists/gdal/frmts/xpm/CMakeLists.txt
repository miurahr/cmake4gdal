add_gdal_driver(TARGET gdal_XPM SOURCES xpmdataset.cpp)
gdal_standard_includes(gdal_XPM)
target_include_directories(gdal_XPM PRIVATE $<TARGET_PROPERTY:gdal_MEM,SOURCE_DIR>)
