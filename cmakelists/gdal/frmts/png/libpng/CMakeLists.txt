add_library(
  libpng STATIC
  png.c
  pngconf.h
  pnggccrd.c
  pngmem.c
  pngread.c
  pngrtran.c
  pngset.c
  pngvcrd.c
  pngwrite.c
  pngwutil.c
  png.h
  pngerror.c
  pngget.c
  pngpread.c
  pngrio.c
  pngrutil.c
  pngtrans.c
  pngwio.c
  pngwtran.c)
if (GDAL_USE_LIBZ_INTERNAL)
  target_include_directories(libpng PRIVATE $<TARGET_PROPERTY:libz,SOURCE_DIR>)
else ()
  target_include_directories(libpng PRIVATE ${ZLIB_INCLUDE_DIRS})
  target_link_libraries(GDAL_LINK_LIBRARY INTERFACE ${ZLIB_LIBRARIES})
endif ()
set_property(TARGET libpng PROPERTY POSITION_INDEPENDENT_CODE ON)
target_link_libraries(GDAL_LINK_LIBRARY INTERFACE libpng)
