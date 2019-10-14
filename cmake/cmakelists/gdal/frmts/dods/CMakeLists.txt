add_gdal_driver(TARGET gdal_DODS
                SOURCES libdap_headers.h dodsdataset2.cpp)
gdal_standard_includes(gdal_DODS)
gdal_target_link_libraries(TARGET gdal_DODS LIBRARIES DAP::DAP DAP::CLIENT )
gdal_target_link_libraries(TARGET gdal_DODS LIBRARIES LibXml2::LibXml2)

if(DAP_VERSION VERSION_GREATER 3.10 OR DAP_VERSION VERSION_EQUAL 3.10)
    target_compile_definitions(gdal_DODS PRIVATE DEFINITIONS -DLIBDAP_310)
endif()
if(DAP_VERSION VERSION_GREATER 3.9 OR DAP_VERSION VERSION_EQUAL 3.9)
    target_compile_definitions(gdal_DODS PRIVATE DEFINITIONS -DLIBDAP_39)
endif()
