add_gdal_driver(
  TARGET
  ogr_MVT
  SOURCES
  mvt_tile.cpp
  mvt_tile.h
  mvtutils.cpp
  mvtutils.h
  ogrmvtdataset.cpp
  BUILTIN)
gdal_standard_includes(ogr_MVT)
target_include_directories(ogr_MVT PRIVATE $<TARGET_PROPERTY:ogr_OSM,SOURCE_DIR>)
if (HAVE_GEOS)
  target_include_directories(ogr_MVT PRIVATE ${GEOS_INCLUDE_DIRS})
  target_compile_definitions(ogr_MVT PRIVATE -DHAVE_GEOS=1)
  gdal_target_link_libraries(TARGET ogr_MVT LIBRARIES GEOS::GEOS)
endif ()

if (HAVE_SQLITE3)
  target_include_directories(ogr_MVT PRIVATE ${SQLITE3_INCLUDE_DIRS})
  target_compile_definitions(ogr_MVT PRIVATE -DHAVE_SQLITE)
  gdal_target_link_libraries(TARGET ogr_MVT LIBRARIES SQLITE3::SQLITE3)
endif ()

add_executable(mvt_tile_test EXCLUDE_FROM_ALL mvt_tile_test.cpp)
gdal_standard_includes(mvt_tile_test)
target_link_libraries(mvt_tile_test PRIVATE $<TARGET_NAME:gdal>)
