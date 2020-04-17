add_gdal_driver(TARGET gdal_BPG SOURCES bpgdataset.cpp)
gdal_standard_includes(gdal_BPG)
target_include_directories(gdal_BPG PRIVATE ${BPG_INCLUDE_DIR})
gdal_target_link_libraries(TARGET gdal_BPG LIBRARIES ${BPG_LIBRARY})
