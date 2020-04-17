# dependency from geomedia
add_gdal_driver(
  TARGET
  ogr_PGeo
  SOURCES
  ogr_pgeo.h
  ogrpgeodatasource.cpp
  ogrpgeodriver.cpp
  ogrpgeolayer.cpp
  ogrpgeotablelayer.cpp
  ogrpgeoselectlayer.cpp
  BUILTIN)
gdal_standard_includes(ogr_PGeo)
