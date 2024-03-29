add_gdal_driver(
  TARGET gdal_NITF
  SOURCES mgrs.c
          nitfdataset.cpp
          rpftocdataset.cpp
          nitfrasterband.cpp
          ecrgtocdataset.cpp
          nitffile.c
          nitfimage.c
          nitfaridpcm.cpp
          nitfbilevel.cpp
          rpftocfile.cpp
          nitfdes.c
          nitf_gcprpc.cpp
          nitfwritejpeg.cpp
          nitfwritejpeg_12.cpp
  BUILTIN)
gdal_standard_includes(gdal_NITF)
target_include_directories(gdal_NITF PRIVATE ${GDAL_RASTER_FORMAT_SOURCE_DIR}/gtiff
                                             ${GDAL_RASTER_FORMAT_SOURCE_DIR}/vrt)

if (CMAKE_VERSION VERSION_GREATER_EQUAL 3.16)
  set_property(SOURCE nitfimage.c nitffile.c nitfdes.c PROPERTY SKIP_UNITY_BUILD_INCLUSION ON)
endif ()
if (GDAL_USE_LIBTIFF_INTERNAL)
  target_include_directories(gdal_NITF PRIVATE $<TARGET_PROPERTY:libtiff,SOURCE_DIR>)
  if (RENAME_LIBTIFF_SYMBOLS)
    target_compile_definitions(gdal_NITF PRIVATE -DRENAME_INTERNAL_LIBTIFF_SYMBOLS)
  endif ()
else ()
  target_include_directories(gdal_NITF PRIVATE ${TIFF_INCLUDE_DIR})
  gdal_target_link_libraries(TARGET gdal_NITF LIBRARIES ${TIFF_LIBRARY})
endif ()
if (GDAL_USE_LIBJPEG_INTERNAL)
  target_compile_definitions(gdal_NITF PRIVATE -DJPEG_SUPPORTED)
  target_include_directories(gdal_NITF PRIVATE $<TARGET_PROPERTY:libjpeg,SOURCE_DIR>)
else ()
  if (HAVE_JPEG)
    target_compile_definitions(gdal_NITF PRIVATE -DJPEG_SUPPORTED)
    target_include_directories(gdal_NITF PRIVATE ${JPEG_INCLUDE_DIRS})
    gdal_target_link_libraries(TARGET gdal_NITF LIBRARIES JPEG::JPEG)
  endif ()
endif ()
if (GDAL_USE_LIBJPEG_INTERNAL OR HAVE_JPEG)
  if (GDAL_JPEG12_SUPPORTED)
    target_compile_definitions(gdal_NITF PRIVATE -DJPEG_DUAL_MODE_8_12)
  endif ()
endif ()
