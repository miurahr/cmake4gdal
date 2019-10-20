# ******************************************************************************
# * Project:  CMake4GDAL
# * Purpose:  CMake build scripts
# * Author: Dmitriy Baryshnikov (aka Bishop), polimax@mail.ru, Hiroshi Miura
# ******************************************************************************
# * Copyright (C) 2012,2013 Bishop
# * Copyright (C) 2017,2018 Hiroshi Miura
# *
# * Permission is hereby granted, free of charge, to any person obtaining a
# * copy of this software and associated documentation files (the "Software"),
# * to deal in the Software without restriction, including without limitation
# * the rights to use, copy, modify, merge, publish, distribute, sublicense,
# * and/or sell copies of the Software, and to permit persons to whom the
# * Software is furnished to do so, subject to the following conditions:
# *
# * The above copyright notice and this permission notice shall be included
# * in all copies or substantial portions of the Software.
# *
# * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
# * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# * DEALINGS IN THE SOFTWARE.
# ******************************************************************************

add_library(ogr OBJECT
            ogrgeometryfactory.cpp
            ogrpoint.cpp
            ogrcurve.cpp
            ogrlinestring.cpp
            ogrlinearring.cpp
            ogrpolygon.cpp
            ogrtriangle.cpp
            ogrutils.cpp
            ogrgeometry.cpp
            ogrgeometrycollection.cpp
            ogrmultipolygon.cpp
            ogrsurface.cpp
            ogrpolyhedralsurface.cpp
            ogrtriangulatedsurface.cpp
            ogrmultipoint.cpp
            ogrmultilinestring.cpp
            ogrcircularstring.cpp
            ogrcompoundcurve.cpp
            ogrcurvepolygon.cpp
            ogrcurvecollection.cpp
            ogrmulticurve.cpp
            ogrmultisurface.cpp
            ogr_api.cpp
            ogrfeature.cpp
            ogrfeaturedefn.cpp
            ogrfeaturequery.cpp
            ogrfeaturestyle.cpp
            ogrfielddefn.cpp
            ogrspatialreference.cpp
            ogr_srsnode.cpp
            ogr_fromepsg.cpp
            ogrct.cpp
            ogr_srs_esri.cpp
            ogr_srs_pci.cpp
            ogr_srs_usgs.cpp
            ogr_srs_dict.cpp
            ogr_srs_panorama.cpp
            ogr_srs_ozi.cpp
            ogr_srs_erm.cpp
            swq.cpp
            swq_expr_node.cpp
            swq_parser.cpp
            swq_select.cpp
            swq_op_registrar.cpp
            swq_op_general.cpp
            ogr_srs_xml.cpp
            ograssemblepolygon.cpp
            ogr2gmlgeometry.cpp
            gml2ogrgeometry.cpp
            ogr_expat.cpp
            ogrpgeogeometry.cpp
            ogrgeomediageometry.cpp
            ogr_geocoding.cpp
            ogrgeomfielddefn.cpp
            ograpispy.cpp
            ogr_xerces.cpp
            ogr_geo_utils.cpp
            ogr_proj_p.cpp

            ogrsf_frmts/ogr_attrind.h
            ogrgeomediageometry.h
            ogrpgeogeometry.h
            ogr_geo_utils.h
            ogr_srs_esri_names.h
            ogr_swq.h
            ogr_expat.h
            ogr_sfcgal.h
            ogr_geocoding.h
            ogr_geos.h
            ogr_libs.h
            ogr_xerces.h
)
include(GdalStandardIncludes)
gdal_standard_includes(ogr)
target_include_directories(ogr PRIVATE $<TARGET_PROPERTY:ogr_geojson,SOURCE_DIR>
                           $<TARGET_PROPERTY:ogr_MEM,SOURCE_DIR>)
set_property(TARGET ogr PROPERTY POSITION_INDEPENDENT_CODE ON)
target_sources(gdal PRIVATE $<TARGET_OBJECTS:ogr>)

target_compile_definitions(ogr PRIVATE HAVE_MITAB)
#TODO: detect whether -DPROJ_STATIC or not.
target_include_directories(ogr PRIVATE ${PROJ_INCLUDE_DIRS})
target_link_libraries(GDAL_LINK_LIBRARY INTERFACE PROJ::PROJ)

if (HAVE_GEOS)
    target_compile_definitions(ogr PRIVATE -DHAVE_GEOS=1)
    target_include_directories(ogr PRIVATE ${GEOS_INCLUDE_DIRS})
    target_link_libraries(GDAL_LINK_LIBRARY INTERFACE GEOS::GEOS)
endif ()

if (HAVE_SFCGAL)
    target_compile_definitions(ogr PRIVATE -DHAVE_SFCGAL=1)
    target_include_directories(ogr PRIVATE ${SFCGAL_INCLUDE_DIRS})
    target_link_libraries(GDAL_LINK_LIBRARY INTERFACE SFCGAL::SFCGAL)
endif ()

target_compile_definitions(ogr PRIVATE -DHAVE_LIBZ -DZIP_SUPPORT)
if (GDAL_USE_LIBZ_INTERNAL)
    target_include_directories(ogr PRIVATE $<TARGET_PROPERTY:libz,SOURCE_DIR>)
else ()
    target_compile_definitions(ogr PRIVATE -DHAVE_ZLIB_H -DHAVE_ZLIB)
    if (MSVC)
        target_compile_definitions(ogr PRIVATE -DZLIB_DLL)
    endif ()
    target_include_directories(ogr PRIVATE ${ZLIB_INCLUDE_DIRS})
    target_link_libraries(GDAL_LINK_LIBRARY INTERFACE ZLIB::ZLIB)
endif ()

if (HAVE_EXPAT)
    target_compile_definitions(ogr PRIVATE -DHAVE_EXPAT)
    target_include_directories(ogr PRIVATE ${EXPAT_INCLUDE_DIRS})
    target_link_libraries(GDAL_LINK_LIBRARY INTERFACE EXPAT::EXPAT)
endif ()

if (HAVE_XERCESC)
    target_sources(ogr PRIVATE ogr_xerces_headers.h)
    target_include_directories(ogr PRIVATE ${XercesC_INCLUDE_DIRS}
                               ${XercesC_INCLUDE_DIRS}/xercesc)
    target_compile_definitions(ogr PRIVATE -DHAVE_XERCES)
    target_link_libraries(GDAL_LINK_LIBRARY INTERFACE XercesC::XercesC)
endif ()

if (HAVE_JSONC)
    target_include_directories(ogr PRIVATE ${JSONC_INCLUDE_DIRS})
    target_link_libraries(GDAL_LINK_LIBRARY INTERFACE JSONC::JSONC)
else ()
    if (GDAL_USE_LIBJSONC_INTERNAL)
        target_include_directories(ogr PRIVATE $<TARGET_PROPERTY:libjson,SOURCE_DIR>)
    endif ()
endif ()

include(TargetPublicHeader)
target_public_header(TARGET gdal HEADERS
                     ogr_api.h
                     ogr_core.h
                     ogr_feature.h
                     ogr_featurestyle.h
                     ogr_geometry.h
                     ogr_p.h
                     ogr_spatialref.h
                     ogr_swq.h
                     ogr_srs_api.h
                     ogrsf_frmts/ogrsf_frmts.h)
