add_gdal_driver(
  TARGET
  ogr_PG
  SOURCES
  ogr_pg.h
  ogrpgutility.h
  ogrpgdatasource.cpp
  ogrpgdriver.cpp
  ogrpglayer.cpp
  ogrpgresultlayer.cpp
  ogrpgtablelayer.cpp
  ogrpgutility.cpp)
gdal_standard_includes(ogr_PG)
if (HAVE_POSTGRESQL)
  target_include_directories(ogr_PG PRIVATE ${PostgreSQL_INCLUDE_DIRS} $<TARGET_PROPERTY:ogr_PGDump,SOURCE_DIR>)
  target_compile_definitions(ogr_PG PRIVATE -DHAVE_PG)
  gdal_target_link_libraries(TARGET ogr_PG LIBRARIES ${PostgreSQL_LIBRARIES})
endif ()
