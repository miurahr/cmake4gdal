add_gdal_driver(
  TARGET ogr_MSSQLSpatial
  SOURCES ogrmssqlgeometryparser.cpp
          ogrmssqlgeometryvalidator.cpp
          ogrmssqlgeometrywriter.cpp
          ogrmssqlspatialdatasource.cpp
          ogrmssqlspatialdriver.cpp
          ogrmssqlspatiallayer.cpp
          ogrmssqlspatialselectlayer.cpp
          ogrmssqlspatialtablelayer.cpp)
gdal_standard_includes(ogr_MSSQLSpatial)
target_include_directories(ogr_MSSQLSpatial PRIVATE ${ODBC_INDLUDE_DIRS})
gdal_target_link_libraries(TARGET ogr_MSSQLSpatial LIBRARIES ODBC::ODBC)
