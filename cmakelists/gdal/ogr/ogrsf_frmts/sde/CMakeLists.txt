option(OGR_ENABLE_SDE_PLUGIN "ON to enable SDE driver build as plugin" ON)
set(_SOURCES ogr_sde.h ogrsdedatasource.cpp ogrsdedriver.cpp ogrsdelayer.cpp)
if (OGR_ENABLE_SDE_PLUGIN)
  add_gdal_driver(
    TARGET ogr_SDE
    SOURCES ${_SOURCES}
    PLUGIN)
else ()
  add_gdal_driver(TARGET ogr_SDE SOURCES ${_SOURCES})
endif ()
gdal_standard_includes(ogr_SDE)
target_include_directories(ogr_SDE PRIVATE ${SDE_INCLUDE_DIRS})
gdal_target_link_libraries(
  TARGET ogr_SDE
         PRIVATE
         ${SDE_LIBRARIES})
