#depend from hdf4 and ogr_PDS
add_gdal_driver(TARGET gdal_PDS SOURCES
                nasakeywordhandler.h
                vicarkeywordhandler.h
                isis2dataset.cpp
                isis3dataset.cpp
                nasakeywordhandler.cpp
                pdsdataset.cpp
                pds4dataset.cpp
                pds4vector.cpp
                vicardataset.cpp
                vicarkeywordhandler.cpp
                BUILTIN
)
if (CMAKE_VERSION VERSION_GREATER_EQUAL 3.16)
  set_property(SOURCE isis2dataset.cpp isis3dataset.cpp pdsdataset.cpp vicardataset.cpp
               PROPERTY SKIP_UNITY_BUILD_INCLUSION ON
               )
endif()
gdal_standard_includes(gdal_PDS)
target_include_directories(gdal_PDS PRIVATE
                           $<TARGET_PROPERTY:ogrsf_generic,SOURCE_DIR>
                           $<TARGET_PROPERTY:gdal_raw,SOURCE_DIR>
                           $<TARGET_PROPERTY:gdal_vrt,SOURCE_DIR>
                           $<TARGET_PROPERTY:ogr_geojson,SOURCE_DIR>
                           $<TARGET_PROPERTY:ogr_VRT,SOURCE_DIR>)
IF(GDAL_USE_LIBJSONC_INTERNAL)
    target_include_directories(gdal_PDS PRIVATE $<TARGET_PROPERTY:libjson,SOURCE_DIR>)
else()
    target_include_directories(gdal_PDS PRIVATE ${JSONC_INCLUDE_DIR})
    gdal_target_link_libraries(TARGET gdal_PDS LIBRARIES JSONC::JSONC)
endif()
