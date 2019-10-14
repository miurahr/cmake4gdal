add_gdal_driver(TARGET ogr_Geomedia
                SOURCES ogr_geomedia.h ogrgeomediadatasource.cpp ogrgeomediadriver.cpp
                       ogrgeomedialayer.cpp ogrgeomediaselectlayer.cpp
                       ogrgeomediatablelayer.cpp)
gdal_standard_includes(ogr_Geomedia)
target_include_directories(ogr_Geomedia PRIVATE $<TARGET_PROPERTY:ogr_PGeo,SOURCE_DIR>
                           ${ODBC_INCLUDE_DIRS})
gdal_target_link_libraries(TARGET ogr_Geomedia LIBRARIES ODBC::ODBC)
