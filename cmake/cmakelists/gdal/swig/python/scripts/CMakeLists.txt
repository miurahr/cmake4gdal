set(PY_UTILS rgb2pct.py esri2wkt.py gdal_sieve.py gdal_retile.py gdal_pansharpen.py
             ogrmerge.py mkgraticule.py gdalident.py gdalchksum.py gdal_auth.py
             gdal_proximity.py gcps2vec.py gdalmove.py pct2rgb.py gcps2wld.py
             gdal_calc.py gdal_fillnodata.py gdal_edit.py gdal_merge.py gdal_polygonize.py
             epsg_tr.py  gdal2xyz.py gdal2tiles.py gdalcompare.py gdalimport.py)
install(PROGRAMS ${PY_UTILS} COMPONENT python DESTINATION bin)