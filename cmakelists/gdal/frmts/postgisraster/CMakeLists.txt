add_gdal_driver(
  TARGET
  gdal_PostGISRaster
  SOURCES
  postgisraster.h
  postgisrasterdataset.cpp
  postgisrasterdriver.cpp
  postgisrasterrasterband.cpp
  postgisrastertiledataset.cpp
  postgisrastertilerasterband.cpp
  postgisrastertools.cpp)
gdal_standard_includes(gdal_PostGISRaster)
target_include_directories(gdal_PostGISRaster PRIVATE $<TARGET_PROPERTY:gdal_vrt,SOURCE_DIR> ${PostgreSQL_INCLUDE_DIRS})
target_compile_definitions(gdal_PostGISRaster PRIVATE -DHAVE_PG)
gdal_target_link_libraries(TARGET gdal_PostGISRaster LIBRARIES ${PostgreSQL_LIBRARIES})
