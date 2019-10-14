
add_gdal_driver(TARGET gdal_JPEGLS SOURCES jpegls_header.h jpeglsdataset.cpp)
gdal_standard_includes(gdal_JPEGLS)
gdal_target_link_libraries(TARGET gdal_JPEGLS LIBRARIES CHARLS::CHARLS)

if(CHARLS_VERSION STREQUAL 1)
    target_compile_definitions(gdal_JPEGLS PRIVATE -DCHARLS_INTERFACE_H)
endif()
