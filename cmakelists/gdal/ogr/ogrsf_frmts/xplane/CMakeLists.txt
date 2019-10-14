add_gdal_driver(TARGET ogr_XPlane SOURCES
                ogr_xplane.h               ogr_xplane_awy_reader.cpp  ogr_xplane_fix_reader.h    ogr_xplane_reader.cpp    ogrxplanedriver.cpp
                ogr_xplane_apt_reader.cpp  ogr_xplane_awy_reader.h    ogr_xplane_nav_reader.cpp  ogr_xplane_reader.h      ogrxplanelayer.cpp
                ogr_xplane_apt_reader.h    ogr_xplane_fix_reader.cpp  ogr_xplane_nav_reader.h    ogrxplanedatasource.cpp
                )
gdal_standard_includes(ogr_XPlane)
