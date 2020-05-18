add_gdal_driver(TARGET ogr_ODBC SOURCES ogrodbcdatasource.cpp ogrodbcdriver.cpp ogrodbclayer.cpp
                                        ogrodbcselectlayer.cpp ogrodbctablelayer.cpp)
gdal_standard_includes(ogr_ODBC)
gdal_target_link_libraries(TARGET ogr_ODBC LIBRARIES ODBC::ODBC ODBC::ODBCINST)