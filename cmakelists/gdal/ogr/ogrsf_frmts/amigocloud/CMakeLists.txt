add_gdal_driver(TARGET ogr_AmigoCloud
                SOURCES ogr_amigocloud.h ogramigoclouddatasource.cpp ogramigoclouddriver.cpp ogramigocloudlayer.cpp
                        ogramigocloudresultlayer.cpp ogramigocloudtablelayer.cpp)
gdal_standard_includes(ogr_AmigoCloud)
target_include_directories(ogr_AmigoCloud PRIVATE $<TARGET_PROPERTY:ogr_PGDump,SOURCE_DIR>
                                                  $<TARGET_PROPERTY:ogr_geojson,SOURCE_DIR>)
if (GDAL_USE_LIBJSONC_INTERNAL)
  target_include_directories(ogr_AmigoCloud PRIVATE $<TARGET_PROPERTY:libjson,SOURCE_DIR>)
else ()
  target_include_directories(ogr_AmigoCloud PRIVATE ${JSONC_INCLUDE_DIRS})
  gdal_target_link_libraries(TARGET ogr_AmigoCloud LIBRARIES ${JSONC_LIBRARIES})
endif ()
