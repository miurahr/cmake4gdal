CMake build system internals for developers
===========================================

CMake is a cross platform tool to beherate build script for
the platform, aka build tool for build system.

Modern CMake
------------

"Modern CMake" style is introduced in CMake3.x version.
In old cmake (2.8.x), definitions are similar to GNU Makefile.
That means sub directories scripts inherit parent definitions.
It is difficult to manage in large project about implicit definitions.

Other than previous cmake versions, modern cmake style controls scope.

There are some modern cmake guides.
* https://rix0r.nl/blog/2015/08/13/cmake-guide/
* https://cliutils.gitlab.io/modern-cmake/
* https://unclejimbo.github.io/2018/06/08/Modern-CMake-for-Library-Developers/

Development status
------------------

- Under active development
- Support PLUGIN drivers
  * Build some drivers as plugin in default for proprietary one and with stronger license
  * Many drivers can be build as plugin, that help dependency management for OS package maintainer.
- Successfully build for
  * GCC4.8 on trusty
  * Clang5 on trusty
  * Clang with plugin enable on trusty
  * Cross compile with android NDK.
  * Cross compile by mingw-w64
    * Test mingw binary with wine.
  * XCode on mac os X
  * Visual Studio 2015 on Windows 64bit
  * Visual Studio 2017 on Windows 32bit
- Implement all OSS drivers.
- Work on current master branch.
- Bindings: c#, perl, php and python.
- Build bindings for both python3 and python2 at once.
- All quick tests are passed on all built platforms.
- There are some limitations
  * Python: install no backward compatibility modules
    only install files under osgeo folder.
  * GRASS driver cannot build at a same time of libgdal.
    It is because of circular dependency.

Known issues and ToDo things(help wanted)
-----------------------------------------

- Issues
  * Mingw: known error on unit-test so specify SKIP_MEM_INTENSIVE_TEST
  * Some autotest cases are not passed yet
    * gcore: tiff_srs_proj4_epsg_*
    * gdrivers: dods, kea, rl2, wms
    * ogr: avc
    * numerical and other errors on Mac OSX in Travis-CI test
        * gcore: hfa_rfc40, tiff_write_13, rasterio
        * gdrivers: aigrid, ozi, pcidsk, usgsdem 
        * alg: applyverticalshiftgrid, reproject, warp
        * ogr: avc, idrisi, osm, pds, rfc41
        * utilities: test_gdalwarp, test_gdalwarp_lib, test_ogr2ogr_lib
        * pyscripts: test_gdal_polygonize, test_gdal_retile

- ToDo
  * Test and fix for proprietary drivers
    * Oracle Spatial
    * Kakadu
    * LULA
    * ESRI ArcSDE
    * Multi-resolution Seamless Image Database
    * ERDAS JPEG2000
    * ogr FME driver
    * IBM DB2
    * MSSQL spatial
    * RASDAMAN
  * build for iOS
    * prepare platform configuration file
    * CI test on Travis
  * Packaging.

Directory structure
-------------------

The cmake related files are located in following directories;

```
<root>
 - cmake4gdal:   cmake modules and helper scripts
   - ci: ci script to test a gdal build with cmake
   - cmakelists: build scripts to deploy gdal source.
   - helpers:  helpers for gdal compilation
   - configurations:  inital cmake cache configuration examples
   - platforms: toolschain files for cross compilation
   - modules:  generic cmake modules to find dependency libraries
     - 3.13:
     - 3.12: backported modules from specified cmake version
     - 3.9:
   - templates: template source files to generate when configure
 - autotest: gdal test suites
 - gdal: gdal source files
```

Build configuration files
--------------------------

There are `CMakeLists.txt` configuration scripts in each directories.
It has all configuration for compilation and link for the directory, with small exception(described later).

System Summary
--------------

Build script generate a summary of host and target environment such as;

```
--   Target system:             Linux
--   Installation directory:    /usr
--   C++ Compiler type:         GNU
--   C compile command line:    ccache /usr/bin/cc
--   C++ compile command line:  ccache /usr/bin/c++
-- 
--   CMAKE_C_FLAGS:              
--   CMAKE_CXX_FLAGS:              
--   CMAKE_CXX11_STANDARD_COMPILE_OPTION:              -std=c++11
--   CMAKE_CXX11_EXTENSION_COMPILE_OPTION:              -std=gnu++11
--   CMAKE_EXE_LINKER_FLAGS:              
--   CMAKE_MODULE_LINKER_FLAGS:              
--   CMAKE_SHARED_LINKER_FLAGS:              
--   CMAKE_STATIC_LINKER_FLAGS:              
--   CMAKE_C_FLAGS_DEBUG:              -g
--   CMAKE_CXX_FLAGS_DEBUG:              -g
--   CMAKE_EXE_LINKER_FLAGS_DEBUG:              
--   CMAKE_MODULE_LINKER_FLAGS_DEBUG:              
--   CMAKE_SHARED_LINKER_FLAGS_DEBUG:              
--   CMAKE_STATIC_LINKER_FLAGS_DEBUG:              
--   CMAKE_C_FLAGS_RELEASE:              -O3 -DNDEBUG
--   CMAKE_CXX_FLAGS_RELEASE:              -O3 -DNDEBUG
--   CMAKE_EXE_LINKER_FLAGS_RELEASE:              
--   CMAKE_MODULE_LINKER_FLAGS_RELEASE:              
--   CMAKE_SHARED_LINKER_FLAGS_RELEASE:              
--   CMAKE_STATIC_LINKER_FLAGS_RELEASE:              
-- 
```

This may help you to debug your compilation.

Configuration Summary
---------------------

Build script generate a summary of enabled and disabled
packages and feature for a build tree using CMake genuine `FeatureSummary`.
Output is as such as::

```
-- Enabled drivers and features and found dependency packages
-- The following features have been enabled:

 * gdal_RAW , Raw formats:EOSAT FAST Format, FARSITE LCP and Vexcel MFF2 Image
 * gdal_ISO8211 , iso8211 library
 * gdal_PNG , PNG image format
 * gdal_JPEG , JPEG image format
```

```
-- The following OPTIONAL packages have been found:

 * ODBC
   Enable DB support thru ODBC
 * Boost
 * CURL
   Enable drivers to use web API
```

```
-- The following RECOMMENDED packages have been found:

 * TIFF (required version >= 4.0) , support for the Tag Image File Format (TIFF). , <http://libtiff.org/>
   gdal_GTIFF: GeoTIFF image format
   gdal_INGR: Intergraph Raster Format
   gdal_CALS: CALS type 1 driver
```

```
-- The following features have been disabled:

 * gdal_SIGDEM , Scaled Integer Gridded DEM .sigdem Driver
 * gdal_MSG , Meteosat Second Generation
```


Logical hierarchy for cmake
----------------------------

CMake has a logical hierarchy built with `add_subdirectory(sub directory path)` function.
Here is a logical hierarchy diagram which is different with physical one.

```
<root>
  - autotest
    - cpp
  - gdal
    - alg
    - gnm
      - gnm_frmts
        - file
        - db
    - apps
    - doc
    - data
    - fuzzers
    - gcore
      - mdreader
    - port
    - ogr
    - swig
      - perl
      - php
      - python
      - java
      - csharp
    - frmts
      - aaigrid
      - ...
      - xyz
      - zmap
    - ogr/ogrsf_frmts
      - aeronavfaa
      - ...
      - xplane
    - alg/internal_libqhull
    - frmts/zlib
    - frmts/pcidsk/sdk
    - ogr/ogrsf_frmts/geojson/libjson
    - ogr/ogrsf_frmts/cad/libopencad
    - frmts/gtiff/libtiff
    - frmts/gtiff/libgeotiff
    - frmts/jpeg/libjpeg
    - frmts/gif/giflib
    - frmts/png/libpng
    - frmts/pcraster/libcsf
    - frmts/mrf/libLERC
    - third_party/LercLib
```

As you know, ogr and ogr/ogrsf_frmts are not parent-child relation but brother node in configuration.
Also all internal 3rd party libraries are handled from gdal root, which means these are logically separeted with
parent project such as geotiff.

Configuration parameters
-------------------------

You can configure build process with  parameters you added to `cmake` command.
Typical usage is as follows;

```
$ cd gdal_project_directory
$ mkdir cmake-build-gcc4.8-debug
$ cd cmake-build-gcc4.8-debug
$ cmake .. -G Ninja -DENABLE_GNM -DGDAL_ENABLE_FRMTS_PDF=ON
$ cmake --build .
$ cmake --build . --target quicktest
```

There are several good example in `gdal/scripts/vagrant` directory.
For example, `gdal-cmake-clang.sh` is a build script with CLang and configured to generate gdal plugins for drivers.

```
cmake \
  -DCMAKE_BUILD_TYPE=Debug \
  -DCMAKE_CXX_COMPILER=clang++-3.9 \
  -DCMAKE_C_COMPILER=clang-3.9 \
  -DCMAKE_CXX_COMPILER_LAUNCHER=ccache \
  -DCMAKE_C_COMPILER_LAUNCHER=ccache \
  -DCMAKE_INSTALL_PREFIX=/usr \
  -DSWIG_PYTHON=ON \
  -DSWIG_PERL=ON \
  -DSWIG_JAVA=ON \
  -DSWIG_CSHARP=ON \
  -DGDAL_ENABLE_FRMT_EPSILON=ON \
  -DGDAL_ENABLE_FRMT_GTA=ON \
  -DGDAL_ENABLE_FRMT_RASTERLITE=ON \
  -DGDAL_ENABLE_FRMT_HDF5=ON \
  -DGDAL_ENABLE_FRMT_OPENJPEG=ON \
  -DGDAL_ENABLE_FRMT_WEBP=ON \
  -DOGR_ENABLE_SOSI=OFF \
  -DOGR_ENABLE_MYSQL=ON \
  -DOGR_ENABLE_LIBKML=ON \
  -DOGR_ENABLE_CAD=ON -DGDAL_USE_OPENCAD_INTERNAL=ON \
  /vagrant


```

Interactive configuration
-------------------------

You can change build parameters by calling cmake UI
`ccmake .` or `cmake-gui .`


Output directory structure
---------------------------

CMake supports out-of-source build. There is a separate directory for built outputs.

```
cmake-build-debug: main build script such as Makefile or Ninja.rule
  - CMakeFiles: intermediate results and object files.
  - autotest:  test programs
    - cpp: test programs
  - gdal:  libgdal.so
    - gdalplugins: gdal_*.so ogr_*.so plugin artifacts
    - apps: utility commands such as gdal-config gdalinfo ogrinfo etc.
    - html: doxygen generated documents.
    - man: doxygen generated manuals
    - fuzzers: fuzzers utilities
    - swig/python: python bindings
    - swig/csharp: csharp bindings
    - swig/php: php bindings
    - swig/perl: perl bindings
    - swig/java: java bindings
    - CMakeFiles/Export: cmake exported config files
```

Build documents
----------

To build API documents, please run

```
$ cmake --build . --target doc
$ cmake --build . --target man
```

To build documents, you need Doxygen document generation tool.


Run test
---------

You can run test by command line on build output directory root.

```
$ cmake --build . --target quicktest
```

or  if you select GNUMake as a generated system.

```
$ make autotest
```

THere is a test log in `autotest/Testing/Tempolary/LastTest.log`

There are test targets; `quicktest`, `autotest`, `test_sse`,`test_misc`

To run autotest target, you should enable SWIG_PYTHON=ON.

### Test for cross compile

CMake support emulator to run test for example WINE for mingw build.
Default toolchain for mingw defines WINE as an emulator for cross compiling.

Please see https://cmake.org/cmake/help/latest/variable/CMAKE_CROSSCOMPILING_EMULATOR.html for details.


Windows
--------

CMake build script support Windows platform with both MS Visual Stidio(VC) and MSYS2/Mingw.
You can see non-GUI build scripts on appveyor.yml for MSVC and vagrant environment
for cross compiling GDAL using mingw-w64.


Android
---------

The cmake build script includes script to for Andoroid port.
It depends on standard cmake scripts in Android-NDK.

Android NDK requires CMake 3.6 or higher.

Vagrant environment includes dependencies for Android.

If you want to build it by hand, please refer to gdal/script/vagrant/gdal-android.sh

```
cmake \
    -G Ninja \
    -DCMAKE_BUILD_TYPE=Debug \
    -DCMAKE_TOOLCHAIN_FILE=${ANDROID_NDK}/build/cmake/android.toolchain.cmake \
    -DANDROID_TOOLCHAIN=${ANDROID_TOOLCHAIN} \
    -C /vagrant/cmake/init/android.cmake \
    -DSWIG_JAVA=ON \
    ${GDAL_SOURCE}
```

IDE
-----

Modern IDEs(Integrated development environment), such as Visual Studio 17 and later,
JetBrains CLion, Android Studio and VScode, can recogize gdal's CMake build script natively.

CMake support all other development environment by generating configurations for tools.
For example you use XCode, you can specify generator target 'XCode' to generate
build script.

CI tests
--------

Using out-of-source capability, we can reduce test patterns
and run multiple build and test on same environment.

### Travis-CI test cases

- GCC on Ubuntu Trusty

- Clang 5.0 on Ubuntu Trusty

- Cross compile with mingw-w64 on Ubuntu Trusty

- Cross compile for Android on Ubuntu Trusty

- Mac OS X

### AppVeyor CI test cases

- MSVC 2017 for Win32

- MSVC 2015 for Win64

Internal variables
--------------------

### Dependency check results

- HAVE_*: when exist <library> then set ON to HAVE_<LIB>

### Internal libraries

These libraries are automatically detected and when not exist in system, enables internal one.

- GDAL_USE_LIBTIFF_INTERNAL

- GDAL_USE_LIBPNG_INTERNAL

- GDAL_USE_LIBGEOTIFF_INTERNAL

- GDAL_USE_LIBJPEG_INTERNAL

- GDAL_USE_GIFLIB_INTERNAL

- GDAL_USE_LIBJSONC_INTERNAL

- GDAL_USE_OPENCAD_INTERNAL

- GDAL_USE_QHULL_INTERNAL

- GDAL_USE_SHAPELIB_INTERNAL

- GDAL_USE_LIBLERC_INTERNAL

### Manual options for Internal libraries


- GDAL_USE_LIBPCIDSK_INTERNAL: set ON to enable internal libpcidsk sdk

- RENAME_INTERNAL_LIBTIFF_SYMBOLS: set ON to rename internal symbols in libtiff

- GDAL_USE_LIBLERC_INTERNAL: set ON to use internal LibLERC

- SPATIALITE_AMALGAMATION: set ON to use amalgamation for spatialite(for windows)

- RENAME_INTERNAL_SHAPELIB_SYMBOLS 