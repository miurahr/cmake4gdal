add_gdal_driver(
  TARGET
  ogr_GMLAS
  SOURCES
  ogr_gmlas.h
  ogrgmlasdatasource.cpp
  ogrgmlaslayer.cpp
  ogrgmlasutils.cpp
  ogrgmlasxpatchmatcher.cpp
  ogr_gmlas_consts.h
  ogrgmlasdriver.cpp
  ogrgmlasreader.cpp
  ogrgmlaswriter.cpp
  ogrgmlasxsdcache.cpp
  ogrgmlasconf.cpp
  ogrgmlasfeatureclass.cpp
  ogrgmlasschemaanalyzer.cpp
  ogrgmlasxlinkresolver.cpp
  xercesc_headers.h)
gdal_standard_includes(ogr_GMLAS)
target_include_directories(ogr_GMLAS PRIVATE $<TARGET_PROPERTY:ogr_geojson,SOURCE_DIR> $<TARGET_PROPERTY:ogr_MEM,SOURCE_DIR>
                                             $<TARGET_PROPERTY:ogr_PGDump,SOURCE_DIR>)

if (HAVE_XERCESC)
  target_include_directories(ogr_GMLAS PRIVATE ${XercesC_INCLUDE_DIRS} ${XercesC_INCLUDE_DIRS}/xercesc)
  target_compile_definitions(ogr_GMLAS PRIVATE -DHAVE_XERCES=1)
  gdal_target_link_libraries(TARGET ogr_GMLAS LIBRARIES XercesC::XercesC)
endif ()

if (GDAL_USE_LIBJSONC_INTERNAL)
  target_include_directories(ogr_GMLAS PRIVATE $<TARGET_PROPERTY:libjson,SOURCE_DIR>)
else ()
  target_include_directories(ogr_GMLAS PRIVATE ${JSONC_INCLUDE_DIRS})
  gdal_target_link_libraries(TARGET ogr_GMLAS LIBRARIES JSONC::JSONC)
endif ()
