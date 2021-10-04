# depend from hdf4 and ogr_PDS
add_gdal_driver(
  TARGET gdal_PDS
  SOURCES isis2dataset.cpp
          isis3dataset.cpp
          pdsdataset.cpp
          pds4dataset.cpp
          pds4vector.cpp
          vicardataset.cpp
          vicarkeywordhandler.cpp
  BUILTIN)
if (CMAKE_VERSION VERSION_GREATER_EQUAL 3.16)
  set_property(SOURCE isis2dataset.cpp isis3dataset.cpp pdsdataset.cpp vicardataset.cpp vicarkeywordhandler.cpp
                      nasakeywordhandler.cpp PROPERTY SKIP_UNITY_BUILD_INCLUSION ON)
endif ()
gdal_standard_includes(gdal_PDS)
target_include_directories(
  gdal_PDS
  PRIVATE $<TARGET_PROPERTY:ogrsf_generic,SOURCE_DIR> ${GDAL_RASTER_FORMAT_SOURCE_DIR}/raw
          ${GDAL_RASTER_FORMAT_SOURCE_DIR}/vrt ${GDAL_VECTOR_FORMAT_SOURCE_DIR}/geojson
          ${GDAL_VECTOR_FORMAT_SOURCE_DIR}/vrt)
if (GDAL_USE_LIBJSONC_INTERNAL)
  target_include_directories(gdal_PDS PRIVATE $<TARGET_PROPERTY:libjson,SOURCE_DIR>)
else ()
  target_include_directories(gdal_PDS PRIVATE ${JSONC_INCLUDE_DIR})
  gdal_target_link_libraries(TARGET gdal_PDS LIBRARIES JSONC::JSONC)
endif ()
