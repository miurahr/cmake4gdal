Building GDAL with CMake
===========================================

This document describes how to use CMake to configure and build the
GDAL library across different platforms.

Introduction
============

CMake is a cross platform tool to beherate build script for
the platform, aka build tool for build system.

Using CMake, it is possible to build the GDAL library natively on
Windows using Visual Studio, on Mac OS X using XCode, and on Linux.
CMake works on Unix, Linux, Mac OS X and Windows system,
and will generate files for a variety of build systems.


| Operating System | Build system                                |
|------------------|---------------------------------------------|
| Any/All          | Unix Makefiles, CodeBlocks, Eclipse CDT     |
| Windows          | Borland/MSYS/MinGW Makefiles, Visual Studio |
| Linux            | Ninja, KDevelop3                            |
| OSX              | Xcode                                       |

CMake build script for GDAL supports and tested following targets for both 64bit and 32bit OSes.

- Windows (Visual Studio 2015, Visual Studio 2017)
- Windows (MSYS2/Mingw, Cygwin)
- Windows cross build on Linux (mingw-w64)
- Linux (GNU make or Ninja with GCC 4.8+, Clang 3.8+)
- Mac OS X (XCode 8+)
- Android (Android NDK and Ninja on Linux)
- iOS (XCode 8+) (not tested yet)

CMake build script for GDAL tested with following IDEs
for editing source codes and build scripts,

- JetBrains CLion
- VSCode with CMake addon
- Visual Studio 2017


Requirements for building with CMake
====================================

1. GDAL with CMake support
2. CMake http://www.cmake.org
3. Dependency libraries of your choice.

CMake versions and limitations
------------------------------

- 3.5.0: Ubuntu 14.04(LTS) has `cmake3` package.
  Minimum for GDAL project.

- 3.7.1: Minimum for android build.

- 3.9.2: Minimum for android SDK r16+.

- 3.12.0: Introduce `<package>_ROOT` variable and environment
  variables to configure 3rd-party libraries.

Using CMake
===========

Out-of-source Builds
--------------------

The CMake build system discourages 'in-source' builds. Instead, a
build directory is created and used to contain the output of the build
process. From the command line, this may be achieved as follows:

```
$ mkdir cmake-build
$ cd cmake-build
$ cmake ..
```

Compiling GDAL library and utilities
------------------------------------

```
$ cd cmake-build
$ cmake --build .
```

Testing GDAL library and utilities
------------------------------------

```
$ cd cmake-build
$ cmake --build . --target quicktest
$ cmake --build . --target autotest
```

If you want to see output as same behavior as original autotest,
you can run `autotest-compat` target.
When you build with ninja,
you can run `$ ninja quicktest` instead of `cmake` command.
Also `$ make quicktest` when configure to generate for GNU make.

CMake options
-------------

- BUILD_SHARED_LIBS (Off by Default for Windows,
                     On by Default for Unix/Linux)


To see a full list of options, run 'cmake -L' from the command line, or use a CMake GUI.

References
-----------

For additional syntax and options, see the CMake website, FAQ and Wiki available at
<http://www.cmake.org>.


Vagrant build automation environment
====================================

Build targets
=============

### default targets (build by ALL)

- gdal:  main target to build libgdal.so

- doc: build documents and manuals

- apps: build utility applications

- python2_bindings

- python3_bindings

- php_bindings

- perl_bindings

- csharp_bindings

- java_bindings


### test targets

- autotest: run autotest in the source

- quicktest: run quick-test

- test_sse

- test_misc

### fuzzers

- fuzzers: build fuzzers programs and data

### misc utilities

- s57dump

- ceostest

- sdts2shp

- hfatest

- bsb2raw

- aitest

- dumpgeo

- envisat_dump

- dted_test

- dgnwritetest

- dgndump

- osm2osm

- ntfdump

- testparser

- test_load_virtual_ogr

Appendix
========

Configuration parameters
------------------------

### CMake standard options

- BUILD_SHARED_LIBS: build target as shared library

### Custom options

- USE_CPL: set ON to use CPL,Common Portability Library

  * GDAL_USE_ODBC: set ON to build ODBC support in Portability Library

  * GDAL_USE_XMLREFORMAT: set ON to build XML reformat feature in Portability Library.

- ENABLE_GNM: set ON to use GNM driver

- ENABLE_PAM: set ON to enable PAM

- BUILD_APPS: set ON to build utility applications

- BUILD_DOCS: set ON to build documentations

- GDAL_ENABLE_PLUGIN: set ON to build drivers as plugin

- GDAL_ENABLE_QHULL: set ON to build QHULL support

- GDAL_USE_CURL: set ON to use CURL

- GDAL_USE_LIBZ: set ON to use LIBZ.


### Set Internal libraries

- GDAL_USE_LIBPCIDSK_INTERNAL: set ON to enable internal libpcidsk sdk

- RENAME_INTERNAL_LIBTIFF_SYMBOLS: set ON to rename internal symbols in libtiff

- GDAL_USE_LIBLERC_INTERNAL: set ON to use internal LibLERC

- SPATIALITE_AMALGAMATION: set ON to use amalgamation for spatialite(for windows)

### Drivers

- GDAL_ENABLE_FRMT_ADRG
- GDAL_ENABLE_FRMT_AIGRID
- GDAL_ENABLE_FRMT_AAIGRID
- GDAL_ENABLE_FRMT_AIRSAR
- GDAL_ENABLE_FRMT_ARG
- GDAL_ENABLE_FRMT_BMP
- GDAL_ENABLE_FRMT_BSB
- GDAL_ENABLE_FRMT_CALS
- GDAL_ENABLE_FRMT_CEOS
- GDAL_ENABLE_FRMT_CEOS2
- GDAL_ENABLE_FRMT_COASP
- GDAL_ENABLE_FRMT_COSAR
- GDAL_ENABLE_FRMT_CTG
- GDAL_ENABLE_FRMT_DDS
- GDAL_ENABLE_FRMT_DIMAP
- GDAL_ENABLE_FRMT_DODS
- GDAL_ENABLE_FRMT_DTED
- GDAL_ENABLE_FRMT_E00GRID
- GDAL_ENABLE_FRMT_EEDA
- GDAL_ENABLE_FRMT_ELAS
- GDAL_ENABLE_FRMT_ENVISAT
- GDAL_ENABLE_FRMT_EPSILON
- GDAL_ENABLE_FRMT_FIT
- GDAL_ENABLE_FRMT_FITS
- GDAL_ENABLE_FRMT_GIF
- GDAL_ENABLE_FRMT_GTA
- GDAL_ENABLE_FRMT_GFF
- GDAL_ENABLE_FRMT_GIF
- GDAL_ENABLE_FRMT_GRIB
- GDAL_ENABLE_FRMT_GSG
- GDAL_ENABLE_FRMT_GTA
- GDAL_ENABLE_FRMT_GTIFF
- GDAL_ENABLE_FRMT_GXF
- GDAL_ENABLE_FRMT_HDF4
- GDAL_ENABLE_FRMT_HDF5
- GDAL_ENABLE_FRMT_HF2
- GDAL_ENABLE_FRMT_HFA
- GDAL_ENABLE_FRMT_IDRISI
- GDAL_ENABLE_FRMT_IGNFHEIGHTASCIIGRID
- GDAL_ENABLE_FRMT_ILWIS
- GDAL_ENABLE_FRMT_INGR
- GDAL_ENABLE_FRMT_IRIS
- GDAL_ENABLE_FRMT_JAXAPALSAR
- GDAL_ENABLE_FRMT_JDEM
- GDAL_ENABLE_FRMT_JPEG
- GDAL_ENABLE_FRMT_JPEG2000
- GDAL_ENABLE_FRMT_JPEGLS
- GDAL_ENABLE_FRMT_KMLSUPEROVERLAY
- GDAL_ENABLE_FRMT_KEA
- GDAL_ENABLE_FRMT_L1B
- GDAL_ENABLE_FRMT_LEVELLER
- GDAL_ENABLE_FRMT_MAP
- GDAL_ENABLE_FRMT_MBTILES
- GDAL_ENABLE_FRMT_MEM
- GDAL_ENABLE_FRMT_MRF
- GDAL_ENABLE_FRMT_MSGN
- GDAL_ENABLE_FRMT_NETCDF
- GDAL_ENABLE_FRMT_NGSGEOID
- GDAL_ENABLE_FRMT_NITF
- GDAL_ENABLE_FRMT_OPENJPEG
- GDAL_ENABLE_FRMT_OZI
- GDAL_ENABLE_FRMT_PCIDSK
- GDAL_ENABLE_FRMT_PCRASTER
- GDAL_ENABLE_FRMT_POSTGISRASTER
- GDAL_ENABLE_FRMT_PDF
- GDAL_ENABLE_FRMT_PDS
- GDAL_ENABLE_FRMT_PLMOSAIC
- GDAL_ENABLE_FRMT_PNG
- GDAL_ENABLE_FRMT_POSTGISRASTER
- GDAL_ENABLE_FRMT_PRF
- GDAL_ENABLE_FRMT_R
- GDAL_ENABLE_FRMT_RAW
- GDAL_ENABLE_FRMT_RASTERLITE
- GDAL_ENABLE_FRMT_RDA
- GDAL_ENABLE_FRMT_RIK
- GDAL_ENABLE_FRMT_RMF
- GDAL_ENABLE_FRMT_RS2
- GDAL_ENABLE_FRMT_SAFE
- GDAL_ENABLE_FRMT_SAGA
- GDAL_ENABLE_FRMT_SDTS
- GDAL_ENABLE_FRMT_SENTINEL2
- GDAL_ENABLE_FRMT_SGI
- GDAL_ENABLE_FRMT_TERRAGEN
- GDAL_ENABLE_FRMT_TIL
- GDAL_ENABLE_FRMT_TSX
- GDAL_ENABLE_FRMT_USGSDEM
- GDAL_ENABLE_FRMT_VRT
- GDAL_ENABLE_FRMT_WCS
- GDAL_ENABLE_FRMT_WEBP
- GDAL_ENABLE_FRMT_WMS
- GDAL_ENABLE_FRMT_WMTS
- GDAL_ENABLE_FRMT_XPM
- GDAL_ENABLE_FRMT_XYZ

- OGR_ENABLE_AMIGOCLOUD
- OGR_ENABLE_CAD
- OGR_ENABLE_CARTO
- OGR_ENABLE_CLOUDANT
- OGR_ENABLE_CSW
- OGR_ENABLE_DODS
- OGR_ENABLE_ELASTIC
- OGR_ENABLE_GEOJSON
- OGR_ENABLE_GEOMEDIA
- OGR_ENABLE_GFT
- OGR_ENABLE_GMLAS
- OGR_ENABLE_ILI
- OGR_ENABLE_LIBKML
- OGR_ENABLE_MITAB
- OGR_ENABLE_MONGODB
- OGR_ENABLE_MYSQL
- OGR_ENABLE_NAS
- OGR_ENABLE_PDS
- OGR_ENABLE_PG
- OGR_ENABLE_PLSCENES
- OGR_ENABLE_SOSI
- OGR_ENABLE_SHAPE
- OGR_ENABLE_SQLITE
- OGR_ENABLE_SVG
- OGR_ENABLE_VFK
- OGR_ENABLE_WFS
- OGR_ENALBE_XLS
- OGR_ENABLE_XLSX

- GDAL_ENABLE_FRMT_ECW
- GDAL_ENABLE_FRMT_MRSID
- GDAL_ENABLE_FRMT_MRSID_LIDAR
- GDAL_ENABLE_FRMT_SDE
- OGR_ENABLE_DWG
- OGR_ENABLE_FME
- OGR_ENABLE_OCI
- OGR_ENABLE_DB2
- OGR_ENABLE_MSSQLSPATIAL
- OGR_ENABLE_ODS
- OGR_ENABLE_OGDI
- OGR_ENABLE_SDE

- GDAL_ENABLE_FRMT_GRASS
- OGR_ENABLE_GRASS

### Language bindings

There are 5 language bindings are integrated into gdal source tree.

- SWIG_PYTHON: python bindings, default ON, it is required to run autotest

  * PYTHON_VERSION: specify what version to build module. if not specified, preferably search python3
    then see python2.

- SWIG_CSHARP: c# bindings built by .NET or MONO

- SWIG_PHP: PHP bindings

- SWIG_JAVA: Java bindings as JNI

- SWIG_PERL: Perl bindings.

