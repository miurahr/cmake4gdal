add_gdal_driver(TARGET ogr_BNA SOURCES ogr_bna.h ogrbnadatasource.cpp
        ogrbnadriver.cpp ogrbnalayer.cpp ogrbnaparser.cpp ogrbnaparser.h)
gdal_standard_includes(ogr_BNA)
