add_gdal_driver(
  TARGET
  gdal_SDE
  SOURCES
  gdal_sde.h
  sdedataset.h
  sderasterband.h
  sdedataset.cpp
  sdeerror.cpp
  sderasterband.cpp
  PLUGIN)
gdal_standard_includes(gdal_SDE)
target_include_directories(gdal_SDE PRIVATE $<TARGET_PROPERTY:iso8211,SOURCE_DIR>)
gdal_target_link_libraries(TARGET gdal_SDE LIBRARIES SDE::SDE)
