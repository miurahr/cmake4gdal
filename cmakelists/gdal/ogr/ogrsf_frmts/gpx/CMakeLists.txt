add_gdal_driver(TARGET ogr_GPX SOURCES ogr_gpx.h ogrgpxdatasource.cpp ogrgpxdriver.cpp ogrgpxlayer.cpp)
gdal_standard_includes(ogr_GPX)

if (HAVE_EXPAT)
  target_compile_definitions(ogr_GPX PRIVATE -DHAVE_EXPAT=1)
  target_include_directories(ogr_GPX PRIVATE ${EXPAT_INCLUDE_DIRS})
  gdal_target_link_libraries(TARGET ogr_GPX LIBRARIES EXPAT::EXPAT)
endif ()
