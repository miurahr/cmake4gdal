add_gdal_driver(TARGET gdal_GRIB SOURCES
                gribdataset.cpp
                gribcreatecopy.cpp
                degrib/degrib/clock.c
                degrib/degrib/degrib1.cpp
                degrib/degrib/degrib2.cpp
                degrib/degrib/inventory.cpp
                degrib/degrib/metaname.cpp
                degrib/degrib/myerror.c
                degrib/degrib/grib1tab.cpp
                degrib/degrib/myutil.c
                degrib/degrib/metaparse.cpp
                degrib/degrib/weather.c
                degrib/degrib/metaprint.cpp
                degrib/degrib/grib2api.c
                degrib/degrib/myassert.c
                degrib/degrib/scan.c
                degrib/degrib/tendian.cpp
                degrib/g2clib/gridtemplates.c
                degrib/g2clib/drstemplates.c
                degrib/g2clib/pdstemplates.c
                degrib/g2clib/gbits.c
                degrib/g2clib/g2_free.c
                degrib/g2clib/g2_unpack1.c
                degrib/g2clib/g2_unpack2.c
                degrib/g2clib/g2_unpack3.c
                degrib/g2clib/g2_unpack4.c
                degrib/g2clib/g2_unpack5.c
                degrib/g2clib/g2_unpack6.c
                degrib/g2clib/g2_unpack7.c
                degrib/g2clib/g2_info.c
                degrib/g2clib/g2_getfld.c
                degrib/g2clib/simunpack.c
                degrib/g2clib/comunpack.c
                degrib/g2clib/pack_gp.c
                degrib/g2clib/reduce.c
                degrib/g2clib/specunpack.c
                degrib/g2clib/rdieee.c
                degrib/g2clib/mkieee.c
                degrib/g2clib/int_power.c
                degrib/g2clib/simpack.c
                degrib/g2clib/compack.c
                degrib/g2clib/cmplxpack.c
                degrib/g2clib/misspack.c
                degrib/g2clib/dec_jpeg2000.cpp
                degrib/g2clib/jpcunpack.c
                degrib/degrib/hazard.c
)
SET(HEADER_FILES
    gribdataset.h
    degrib/degrib/clock.h
    degrib/degrib/datasource.h
    degrib/degrib/filedatasource.h
    degrib/degrib/memorydatasource.h
    degrib/degrib/degrib1.h
    degrib/degrib/degrib2.h
    degrib/degrib/engribapi.h
    degrib/degrib/grib2api.h
    degrib/degrib/inventory.h
    degrib/degrib/scan.h
    degrib/degrib/meta.h
    degrib/degrib/metaname.h
    degrib/degrib/myutil.h
    degrib/degrib/myerror.h
    degrib/degrib/tdlpack.h
    degrib/degrib/type.h
    degrib/degrib/weather.h
    degrib/degrib/hazard.h
    degrib/degrib/tendian.h
    degrib/g2clib/drstemplates.h
    degrib/g2clib/grib2.h
    degrib/g2clib/gridtemplates.h
    degrib/g2clib/pdstemplates.h
    )
SET(UNUSED_SOURCES
        gribdataset.cpp
        gribcreatecopy.cpp
        degrib/degrib/engribapi.c
        degrib/degrib/tdlpack.cpp
        degrib/g2clib/g2_addfield.c
        degrib/g2clib/g2_addgrid.c
        degrib/g2clib/g2_addlocal.c
        degrib/g2clib/g2_create.c
        degrib/g2clib/g2_miss.c
        degrib/g2clib/getdim.c
        degrib/g2clib/getpoly.c
        degrib/g2clib/g2_gribend.c
        degrib/g2clib/jpcpack.c
        degrib/g2clib/seekgb.c
        degrib/g2clib/specpack.c
        degrib/g2clib/enc_jpeg2000.c
)

gdal_standard_includes(gdal_GRIB)
target_include_directories(gdal_GRIB PRIVATE
                           $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/degrib/degrib>
                           $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/degrib/g2clib>
                           $<TARGET_PROPERTY:gdal_MEM,SOURCE_DIR>)
if(GDAL_USE_LIBPNG_INTERNAL)
    target_include_directories(gdal_GRIB PRIVATE $<TARGET_PROPERTY:libpng,SOURCE_DIR>)
    target_compile_definitions(gdal_GRIB PRIVATE -DUSE_PNG)
    target_sources(gdal_GRIB PRIVATE degrib/g2clib/pngunpack.c degrib/g2clib/dec_png.c)
else()
    target_compile_definitions(gdal_GRIB PRIVATE -DUSE_PNG)
    target_include_directories(gdal_GRIB PRIVATE ${PNG_INCLUDE_DIRS})
    gdal_target_link_libraries(TARGET gdal_GRIB LIBRARIES PNG::PNG)
    target_sources(gdal_GRIB PRIVATE degrib/g2clib/pngunpack.c degrib/g2clib/dec_png.c)
endif()
if(GDAL_USE_LIBZ_INTERNAL)
    target_include_directories(gdal_GRIB PRIVATE $<TARGET_PROPERTY:libz,SOURCE_DIR>)
else()
    target_include_directories(gdal_GRIB PRIVATE ${ZLIB_INCLUDE_DIRS})
    gdal_target_link_libraries(TARGET gdal_GRIB LIBRARIES ZLIB::ZLIB)
endif()
