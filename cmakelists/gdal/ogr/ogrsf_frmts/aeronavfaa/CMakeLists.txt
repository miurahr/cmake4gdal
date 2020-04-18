add_gdal_driver(TARGET ogr_AeronavFAA SOURCES ogr_aeronavfaa.h ograeronavfaadatasource.cpp ograeronavfaadriver.cpp
                                              ograeronavfaalayer.cpp)
gdal_standard_includes(ogr_AeronavFAA)
target_include_directories(ogr_AeronavFAA PRIVATE $<TARGET_PROPERTY:ogr_XPlane>)
