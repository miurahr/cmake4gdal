add_gdal_driver(TARGET ogr_BNA SOURCES ogrbnadatasource.cpp ogrbnadriver.cpp ogrbnalayer.cpp ogrbnaparser.cpp)
gdal_standard_includes(ogr_BNA)
