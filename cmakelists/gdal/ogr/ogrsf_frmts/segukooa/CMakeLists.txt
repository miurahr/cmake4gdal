add_gdal_driver(TARGET ogr_SEGUKOOA SOURCES ogr_segukooa.h ogrsegukooadatasource.cpp ogrsegukooadriver.cpp
                                            ogrsegukooalayer.cpp)
gdal_standard_includes(ogr_SEGUKOOA)
