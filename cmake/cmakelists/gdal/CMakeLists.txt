# ******************************************************************************
# * Project:  CMake4GDAL
# * Purpose:  CMake build scripts
# * Author: Hiroshi Miura, Dmitriy Baryshnikov (aka Bishop), polimax@mail.ru
# ******************************************************************************
# * Copyright (C) 2017,2018 Hiroshi Miura
# * Copyright (C) 2012,2013 Bishop
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

# Switches to control build targets(cached)
option(USE_CPL "Set ON to use cpl" ON)
option(ENABLE_GNM "Build GNM module" ON)
option(ENABLE_PAM "Set ON to enable pam" ON)
option(BUILD_APPS "Build command utilities" ON)
option(BUILD_DOCS "Build documents" ON)
option(GDAL_ENABLE_PLUGIN "Set ON prefer to build most drivers as plugin" OFF)
option(GDAL_ENABLE_QHULL "use qhull" ON)
option(GDAL_USE_LIBPCIDSK_INTERNAL "Set ON to build pcidsk driver with internal sdk" OFF)
option(ENABLE_LTO "Enable Link-Time Optimization if possible" ON)
option(GDAL_ENABLE_MACOSX_FRAMEWORK "Enable Framework on Mac OS X" OFF)

# Default definitions during build
add_definitions(-DGDAL_COMPILATION)

if(ENABLE_LTO)
    if (POLICY CMP0069)
      include(CheckIPOSupported)
      check_ipo_supported(RESULT result)
      if(result)
       set(CMAKE_INTERPROCEDURAL_OPTIMIZATION True)
      endif()
    endif()
endif()

################################################################################
# generate ${CMAKE_CURRENT_BINARY_DIR}/gcore/gdal_version.h
# and set GDAL_VERSION variable
include(GdalVersion)

################################################################
# find 3rd party libraries
include(CheckDependentLibraries)

# generate ${CMAKE_CURRENT_BINARY_DIR}/port/cpl_config.h
include(configure)

################################################################################
## libgdal shared/satic library generation
option(BUILD_SHARED_LIBS "Set ON to build shared library" ON)
add_library(gdal gcore/gdal.h)
add_library(GDAL_LINK_LIBRARY INTERFACE)
target_link_libraries(gdal PRIVATE $<TARGET_NAME:GDAL_LINK_LIBRARY>)
set_property(TARGET gdal PROPERTY PLUGIN_OUTPUT_DIR ${CMAKE_CURRENT_BINARY_DIR}/gdalplugins)
file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/gdalplugins)

# Set project and C++ Standard properties
set_target_properties(gdal PROPERTIES
                      PROJECT_LABEL ${PROJECT_NAME}
                      VERSION ${GDAL_VERSION}
                      SOVERSION ${GDAL_SOVERSION}
                      ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
                      LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
                      RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
                      CXX_STANDARD 11
                      CXX_STANDARD_REQUIRED YES)

if(MINGW)
    list(FIND CMAKE_EXE_LINKER_FLAGS "-municode" has_municode)
    if(NOT has_unicode)
        SET(CMAKE_EXE_LINKER_FLAGS ${CMAKE_EXE_LINKER_FLAGS} "-municode")
    endif()
    if(TARGET_CPU MATCHES "x86_64")
        add_definitions(-m64)
    endif()
endif()

################################################################################
# Install properties
if(GDAL_ENABLE_MACOSX_FRAMEWORK)
    set(INSTALL_PLUGIN_DIR "${CMAKE_INSTALL_PREFIX}/PlugIns"
            CACHE PATH "Installation direcotry for plugins")
    set(CMAKE_MACOSX_RPATH ON)
    set_target_properties(gdal PROPERTIES
                          FRAMEWORK TRUE
                          FRAMEWORK_VERSION A
                          MACOSX_FRAMEWORK_SHORT_VERSION_STRING ${GDAL_VERSION_MAJOR}.${GDAL_VERSION_MINOR}
                          MACOSX_FRAMEWORK_BUNDLE_VERSION "GDAL ${GDAL_VERSION_MAJOR}.${GDAL_VERSION_MINOR}"
                          MACOSX_FRAMEWORK_IDENTIFIER org.osgeo.libgdal
                          XCODE_ATTRIBUTE_INSTALL_PATH "@rpath"
                          INSTALL_NAME_DIR "${CMAKE_INSTALL_PREFIX}"
                          BUILD_WITH_INSTALL_RPATH TRUE
                          #MACOSX_FRAMEWORK_INFO_PLIST "${CMAKE_CURRENT_SOURCE_DIR}/info.plist.in"
                          )
else()
    include(GNUInstallDirs)
    set(INSTALL_PLUGIN_DIR
        "${CMAKE_INSTALL_PREFIX}/lib/gdalplugins/${GDAL_VERSION_MAJOR}.${GDAL_VERSION_MINOR}"
        CACHE PATH "Installation direcotry for plugins")
endif()

###############################################################################
# detect portability libs and set, so it should add at first
# Common Portability layer
add_subdirectory(port)

# Configure internal libraries
if(GDAL_ENABLE_QHULL AND GDAL_USE_QHULL_INTERNAL)
    add_subdirectory(alg/internal_libqhull)
endif()
if(GDAL_USE_LIBZ_INTERNAL)
    add_subdirectory(frmts/zlib)
endif()
if(GDAL_USE_LIBPCIDSK_INTERNAL)
    add_subdirectory(frmts/pcidsk/sdk)
    set(HAVE_PCIDSK ON)
endif()
if(GDAL_USE_LIBJSONC_INTERNAL)
    add_subdirectory(ogr/ogrsf_frmts/geojson/libjson)
endif()
if(GDAL_USE_OPENCAD_INTERNAL AND OGR_ENABLE_CAD)
    add_subdirectory(ogr/ogrsf_frmts/cad/libopencad)
endif()
if(GDAL_USE_LIBTIFF_INTERNAL)
    option(RENAME_INTERNAL_LIBTIFF_SYMBOLS "Rename internal libtiff symbols" OFF)
    add_subdirectory(frmts/gtiff/libtiff)
endif()
if(GDAL_USE_LIBGEOTIFF_INTERNAL)
    add_subdirectory(frmts/gtiff/libgeotiff)
endif()
if(GDAL_USE_LIBJPEG_INTERNAL)
    add_subdirectory(frmts/jpeg/libjpeg)
endif()
if(GDAL_USE_GIFLIB_INTERNAL)
    add_subdirectory(frmts/gif/giflib)
endif()
if(GDAL_USE_LIBPNG_INTERNAL)
    add_subdirectory(frmts/png/libpng)
endif()
if(GDAL_USE_LIBCSF_INTERNAL)
    add_subdirectory(frmts/pcraster/libcsf)
endif()
if(GDAL_USE_LIBLERC_INTERNAL)
    add_subdirectory(frmts/mrf/libLERC)
    add_subdirectory(third_party/LercLib)
endif()
if(GDAL_USE_SHAPELIB_INTERNAL)
    option(RENAME_INTERNAL_SHAPELIB_SYMBOLS "Rename internal Shapelib symbols" ON)
endif()

# Core components
add_subdirectory(alg)
add_subdirectory(ogr)
if(ENABLE_GNM)
    add_subdirectory(gnm)
endif()
add_subdirectory(gcore)

# Raster/Vector drivers (built-in and plugins)
add_subdirectory(frmts)
add_subdirectory(ogr/ogrsf_frmts)

# Bindings
add_subdirectory(swig)

# Utilities
add_subdirectory(apps)

# Document/Manuals
if(BUILD_DOCS)
    add_subdirectory(doc)
endif()

## MSVC spefific resource preparation
if(MSVC)
    target_sources(gdal PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/gcore/Version.rc)
    source_group("Resource Files" FILES ${CMAKE_CURRENT_SOURCE_DIR}/gcore/Version.rc)
    gdal_standard_includes(gdal)
    if(CMAKE_CL_64)
		set_target_properties(gdal PROPERTIES STATIC_LIBRARY_FLAGS "/machine:x64")
    endif()
endif()

## Windows(Mingw/MSVC) link libraries
if (CMAKE_SYSTEM_NAME MATCHES "Windows")
    target_link_libraries(gdal PRIVATE wsock32 ws2_32 psapi)
endif()

get_property(_plugins GLOBAL PROPERTY PLUGIN_MODULES )
add_custom_target(gdal_plugins DEPENDS ${_plugins})

################################################################################
configure_file(${GDAL_CMAKE_TEMPLATE_PATH}/gdal_def.h.in
               ${CMAKE_CURRENT_BINARY_DIR}/gcore/gdal_def.h @ONLY)

################################################################################
set_property(TARGET gdal APPEND PROPERTY PUBLIC_HEADER ${CMAKE_CURRENT_BINARY_DIR}/port/cpl_config.h)

set(GDAL_DATA_FILES
    data/GDALLogoBW.svg data/GDALLogoColor.svg data/GDALLogoGS.svg data/bag_template.xml data/compdcs.csv
    data/coordinate_axis.csv data/cubewerx_extra.wkt data/datum_shift.csv data/default.rsc
    data/ecw_cs.wkt data/eedaconf.json data/ellipsoid.csv data/epsg.wkt data/esri_StatePlane_extra.wkt
    data/esri_Wisconsin_extra.wkt data/esri_epsg.wkt data/esri_extra.wkt data/gcs.csv data/gcs.override.csv
    data/gdal_datum.csv data/gdalicon.png data/gdalvrt.xsd data/geoccs.csv data/gml_registry.xml
    data/gmlasconf.xml data/gmlasconf.xsd data/gt_datum.csv data/gt_ellips.csv data/header.dxf
    data/inspire_cp_BasicPropertyUnit.gfs data/inspire_cp_CadastralBoundary.gfs data/inspire_cp_CadastralParcel.gfs
    data/inspire_cp_CadastralZoning.gfs data/jpfgdgml_AdmArea.gfs data/jpfgdgml_AdmBdry.gfs data/jpfgdgml_AdmPt.gfs
    data/jpfgdgml_BldA.gfs data/jpfgdgml_BldL.gfs data/jpfgdgml_Cntr.gfs
    data/jpfgdgml_CommBdry.gfs data/jpfgdgml_CommPt.gfs data/jpfgdgml_Cstline.gfs data/jpfgdgml_ElevPt.gfs
    data/jpfgdgml_GCP.gfs data/jpfgdgml_LeveeEdge.gfs data/jpfgdgml_RailCL.gfs data/jpfgdgml_RdASL.gfs
    data/jpfgdgml_RdArea.gfs data/jpfgdgml_RdCompt.gfs data/jpfgdgml_RdEdg.gfs data/jpfgdgml_RdMgtBdry.gfs
    data/jpfgdgml_RdSgmtA.gfs data/jpfgdgml_RvrMgtBdry.gfs data/jpfgdgml_SBAPt.gfs data/jpfgdgml_SBArea.gfs
    data/jpfgdgml_SBBdry.gfs data/jpfgdgml_WA.gfs data/jpfgdgml_WL.gfs
    data/jpfgdgml_WStrA.gfs data/jpfgdgml_WStrL.gfs data/netcdf_config.xsd data/nitf_spec.xml data/nitf_spec.xsd
    data/ogrvrt.xsd data/osmconf.ini data/ozi_datum.csv data/ozi_ellips.csv data/pci_datum.txt data/pci_ellips.txt
    data/pcs.csv data/pcs.override.csv data/pds4_template.xml data/plscenesconf.json data/prime_meridian.csv
    data/projop_wparm.csv data/ruian_vf_ob_v1.gfs data/ruian_vf_st_uvoh_v1.gfs data/ruian_vf_st_v1.gfs
    data/ruian_vf_v1.gfs data/s57agencies.csv data/s57attributes.csv data/s57expectedinput.csv data/s57objectclasses.csv
    data/seed_2d.dgn data/seed_3d.dgn data/stateplane.csv data/trailer.dxf data/unit_of_measure.csv data/vdv452.xml
    data/vdv452.xsd data/vertcs.csv data/vertcs.override.csv)
set_property(TARGET gdal APPEND PROPERTY RESOURCE "${GDAL_DATA_FILES}")

install(TARGETS gdal EXPORT gdal-export
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
        ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
        RESOURCE DESTINATION ${CMAKE_INSTALL_DATADIR}/gdal
        PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/gdal
        FRAMEWORK DESTINATION ${CMAKE_INSTALL_LIBDIR}
)

if(UNIX AND NOT GDAL_ENABLE_MACOSX_FRAMEWORK)
    # Genarate GdalConfig.cmake and GdalConfigVersion.cmake
    export(EXPORT gdal-export
           FILE gdal-export.cmake)
    install(EXPORT gdal-export
            FILE GdalConfig.cmake
            DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/gdal/
            EXPORT_LINK_INTERFACE_LIBRARIES)
    include(CMakePackageConfigHelpers)
    write_basic_package_version_file(GdalConfigVersion.cmake
                                     VERSION ${GDAL_VERSION}
                                     ## SameMinorVersion compatibility are supported CMake > 3.10.1
                                     ## so use ExactVersion instead.
                                     # COMPATIBILITY SameMinorVersion)
                                     COMPATIBILITY ExactVersion)
    install(FILES ${CMAKE_CURRENT_BINARY_DIR}/GdalConfigVersion.cmake
            DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/gdal/)

    # gdal-config utility command generation
    include(GenerateConfig)
    set(CONFIG_DATA "${GDAL_PREFIX}/share/gdal/${GDAL_VERSION_MAJOR}.${GDAL_VERSION_MINOR}")
    if(ENABLE_GNM)
        set(CONFIG_GNM_ENABLED "yes")
    else()
        set(CONFIG_GNM_ENABLED "no")
    endif()
    get_property(_GDAL_FORMATS GLOBAL PROPERTY GDAL_FORMATS)
    get_property(_OGR_FORMATS GLOBAL PROPERTY OGR_FORMATS)
    string(REPLACE ";" " " CONFIG_FORMATS "${_GDAL_FORMATS} ${_OGR_FORMATS}")
    generate_config(gdal GDAL_LINK_LIBRARY ${GDAL_CMAKE_TEMPLATE_PATH}/gdal-config.in
                    ${CMAKE_BINARY_DIR}/gdal/apps/gdal-config)
    add_custom_target(gdal_config ALL DEPENDS ${CMAKE_BINARY_DIR}/gdal/apps/gdal-config)
    install(PROGRAMS ${CMAKE_BINARY_DIR}/gdal/apps/gdal-config
            DESTINATION bin
            PERMISSIONS OWNER_READ OWNER_WRITE OWNER_EXECUTE GROUP_READ GROUP_EXECUTE WORLD_READ WORLD_EXECUTE
            COMPONENT applications)
    # pkg-config resource
    configure_file(${GDAL_CMAKE_TEMPLATE_PATH}/gdal.pc.in
                   ${CMAKE_CURRENT_BINARY_DIR}/gdal.pc @ONLY)
    install(FILES ${CMAKE_CURRENT_BINARY_DIR}/gdal.pc DESTINATION ${CMAKE_INSTALL_LIBDIR}/pkgconfig
            COMPONENT libraries)
endif()

################################################################################
configure_file(${GDAL_CMAKE_TEMPLATE_PATH}/uninstall.cmake.in
               ${CMAKE_BINARY_DIR}/cmake_uninstall.cmake IMMEDIATE @ONLY)
add_custom_target(uninstall
                  COMMAND ${CMAKE_COMMAND} -P ${CMAKE_CURRENT_BINARY_DIR}/cmake_uninstall.cmake)

################################################################################
## Print summry
include(SystemSummary)
system_summary(DESCRIPTION "GDAL is now configured on;")

include(FeatureSummary)
feature_summary(DESCRIPTION "Enabled drivers and features and found dependency packages"
                WHAT ALL)

# vim: ts=4 sw=4 sts=4 et
