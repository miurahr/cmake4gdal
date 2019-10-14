add_gdal_driver(TARGET ogr_FlatGeobuf
                SOURCES feature_generated.h header_generated.h ogr_flatgeobuf.h
                ogrflatgeobufdataset.cpp ogrflatgeobuflayer.cpp packedrtree.cpp packedrtree.h)
gdal_standard_includes(ogr_FlatGeobuf)
