# referenced from frmts/northwood driver
add_gdal_driver(TARGET ogr_TAB DEF TAB_ENABLED BUILTIN
                SOURCES
    mitab.h                mitab_geometry.cpp       mitab_mapfile.cpp         mitab_miffile.cpp         mitab_spatialref.cpp   mitab_utils.h
    mitab_bounds.cpp       mitab_geometry.h         mitab_mapheaderblock.cpp  mitab_ogr_datasource.cpp  mitab_tabfile.cpp
    mitab_coordsys.cpp     mitab_idfile.cpp         mitab_mapindexblock.cpp   mitab_ogr_driver.cpp      mitab_tabseamless.cpp
    mitab_datfile.cpp      mitab_imapinfofile.cpp   mitab_mapobjectblock.cpp  mitab_ogr_driver.h        mitab_tabview.cpp
    mitab_feature.cpp      mitab_indfile.cpp        mitab_maptoolblock.cpp    mitab_priv.h              mitab_tooldef.cpp
    mitab_feature_mif.cpp  mitab_mapcoordblock.cpp  mitab_middatafile.cpp     mitab_rawbinblock.cpp     mitab_utils.cpp
)
gdal_standard_includes(ogr_TAB)
target_compile_definitions(ogr_TAB PRIVATE -DOGR -DMITAB_USE_OFTDATETIME)
