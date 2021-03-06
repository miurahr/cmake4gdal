add_gdal_driver(
  TARGET gdal_MBTiles
  SOURCES mbtilesdataset.cpp
  BUILTIN)
gdal_standard_includes(gdal_MBTiles)
target_include_directories(gdal_MBTiles PRIVATE $<TARGET_PROPERTY:ogr_MVT,SOURCE_DIR>)
if (GDAL_USE_LIBZ_INTERNAL)
  target_include_directories(gdal_MBTiles PRIVATE $<TARGET_PROPERTY:libz,SOURCE_DIR>)
endif ()
if (HAVE_GEOS)
  target_compile_definitions(gdal_MBTiles PRIVATE -DHAVE_GEOS=1)
  target_include_directories(gdal_MBTiles PRIVATE ${GEOS_INCLUDE_DIRS})
  gdal_target_link_libraries(TARGET gdal_MBTiles LIBRARIES GEOS::GEOS)
endif ()
if (HAVE_SQLITE3)
  target_include_directories(gdal_MBTiles PRIVATE ${SQLITE3_INCLUDE_DIRS})
  target_compile_definitions(gdal_MBTiles PRIVATE -DHAVE_SQLITE)
  gdal_target_link_libraries(TARGET gdal_MBTiles LIBRARIES ${SQLITE3_LIBRARY})
endif ()
if (GDAL_USE_LIBJSONC_INTERNAL)
  target_include_directories(gdal_MBTiles PRIVATE $<TARGET_PROPERTY:libjson,SOURCE_DIR>)
else ()
  target_include_directories(gdal_MBTiles PRIVATE ${JSONC_INCLUDE_DIRS})
  gdal_target_link_libraries(TARGET gdal_MBTiles LIBRARIES ${JSONC_LIBRARIES})
endif ()
target_include_directories(
  gdal_MBTiles PRIVATE $<TARGET_PROPERTY:ogr_geojson,SOURCE_DIR> $<TARGET_PROPERTY:ogr_GeoPackage,SOURCE_DIR>
                       $<TARGET_PROPERTY:ogr_SQLite,SOURCE_DIR>)
