add_gdal_driver(TARGET ogr_ODBC
                SOURCES ogr_odbc.h ogrodbcdatasource.cpp ogrodbcdriver.cpp ogrodbclayer.cpp
                        ogrodbcselectlayer.cpp ogrodbctablelayer.cpp)
gdal_standard_includes(ogr_ODBC)
