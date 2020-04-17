add_gdal_driver(
  TARGET
  gdal_JPEG
  SOURCES
  vsidataio.h
  jpgdataset.h
  vsidataio.cpp
  jpgdataset.cpp
  BUILTIN)
gdal_standard_includes(gdal_JPEG)

target_include_directories(gdal_JPEG PRIVATE $<TARGET_PROPERTY:gdal_MEM,SOURCE_DIR>)
if (GDAL_JPEG12_SUPPORTED)
  target_sources(gdal_JPEG PRIVATE jpgdataset_12.cpp vsidataio_12.cpp)
endif ()

if (GDAL_USE_LIBJPEG_INTERNAL)
  target_include_directories(gdal_JPEG PRIVATE $<TARGET_PROPERTY:libjpeg,SOURCE_DIR>)
else ()
  gdal_target_link_libraries(TARGET gdal_JPEG LIBRARIES JPEG::JPEG)
endif ()

if (GDAL_USE_LIBZ_INTERNAL)
  target_include_directories(gdal_JPEG PRIVATE $<TARGET_PROPERTY:libz,SOURCE_DIR>)
else ()
  gdal_target_link_libraries(TARGET gdal_JPEG LIBRARIES ZLIB::ZLIB)
endif ()
