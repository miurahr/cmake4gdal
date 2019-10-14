add_gdal_driver(TARGET gdal_EPSILON SOURCES epsilondataset.cpp)
gdal_standard_includes(gdal_EPSILON)
target_include_directories(gdal_EPSILON PRIVATE ${EPSILON_INCLUDE_DIRS})
gdal_target_link_libraries(TARGET gdal_EPSILON LIBRARIES EPSILON::Epsilon)
