# reffered from ogr_MVT
add_gdal_driver(
  TARGET ogr_OSM
  SOURCES ogrosmdatasource.cpp ogrosmdriver.cpp ogrosmlayer.cpp osm_parser.cpp
  BUILTIN)
gdal_standard_includes(ogr_OSM)
target_include_directories(ogr_OSM PRIVATE $<TARGET_PROPERTY:ogrsf_generic,SOURCE_DIR>
                                           ${GDAL_VECTOR_FORMAT_SOURCE_DIR}/sqlite)
if (HAVE_EXPAT)
  target_compile_definitions(ogr_OSM PRIVATE -DHAVE_EXPAT=1)
  target_include_directories(ogr_OSM PRIVATE ${EXPAT_INCLUDE_DIRS})
  gdal_target_link_libraries(TARGET ogr_OSM LIBRARIES EXPAT::EXPAT)
endif ()
if (HAVE_SQLITE3)
  target_include_directories(ogr_OSM PRIVATE ${SQLite3_INCLUDE_DIR})
  gdal_target_link_libraries(TARGET ogr_OSM LIBRARIES SQLite::SQLite3)
endif ()
add_executable(osm2osm EXCLUDE_FROM_ALL osm2osm.cpp)
gdal_standard_includes(osm2osm)
target_link_libraries(osm2osm PRIVATE $<TARGET_NAME:gdal>)
