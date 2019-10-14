add_gdal_driver(TARGET gdal_TIL SOURCES tildataset.cpp)
gdal_standard_includes(gdal_TIL)
target_include_directories(gdal_TIL PRIVATE $<TARGET_PROPERTY:gdal_vrt,SOURCE_DIR>)
