add_gdal_driver(TARGET ogr_WFS
                SOURCES ogr_wfs.h ogrwfs3driver.cpp ogrwfsdatasource.cpp ogrwfsdriver.cpp
                ogrwfsfilter.cpp ogrwfsjoinlayer.cpp ogrwfslayer.cpp
                BUILTIN)
gdal_standard_includes(ogr_WFS)
target_include_directories(ogr_WFS PRIVATE $<TARGET_PROPERTY:ogr_GML,SOURCE_DIR>)
