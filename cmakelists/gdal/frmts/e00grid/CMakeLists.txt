add_gdal_driver(TARGET gdal_E00GRID SOURCES e00compr.h e00griddataset.cpp e00read.c)
gdal_standard_includes(gdal_E00GRID)
