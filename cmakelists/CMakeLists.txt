# ******************************************************************************
# * Project:  CMake4GDAL
# * Purpose:  CMake build scripts
# * Author: Dmitriy Baryshnikov (aka Bishop), polimax@mail.ru, Hiroshi Miura
# ******************************************************************************
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

cmake_minimum_required(VERSION 3.5)  # a version of Ubuntu 16.04(LTS)
cmake_policy(SET CMP0023 NEW)
cmake_policy(SET CMP0025 NEW)
cmake_policy(SET CMP0033 NEW)
cmake_policy(SET CMP0034 NEW)
cmake_policy(SET CMP0037 NEW)
cmake_policy(SET CMP0038 NEW)
cmake_policy(SET CMP0039 NEW)
cmake_policy(SET CMP0040 NEW)
cmake_policy(SET CMP0041 NEW)
cmake_policy(SET CMP0042 NEW)
cmake_policy(SET CMP0044 NEW)
cmake_policy(SET CMP0046 NEW)
cmake_policy(SET CMP0048 NEW)
cmake_policy(SET CMP0050 NEW)
cmake_policy(SET CMP0054 NEW)
cmake_policy(SET CMP0057 NEW)
cmake_policy(SET CMP0058 NEW)
cmake_policy(SET CMP0062 NEW)
cmake_policy(SET CMP0064 NEW)

# cmake version 3.6 or later
if (POLICY CMP0068)
  #mac os x rpath effect
  cmake_policy(SET CMP0068 NEW)
endif ()
if (POLICY CMP0069)
  # INTERPROCEDURAL_OPTIMIZATION
  cmake_policy(SET CMP0069 NEW)
endif ()
if (POLICY CMP0070)
  # file(GENERATE)
  cmake_policy(SET CMP0070 NEW)
endif ()
# cmake version 3.11 or later
if (POLICY CMP0073)
  # _LIB_DEPENDS
  cmake_policy(SET CMP0073 NEW)
endif ()
if (POLICY CMP0074)
  # Packagename_ROOT
  cmake_policy(SET CMP0074 NEW)
endif ()
if (POLICY CMP0075)
  cmake_policy(SET CMP0075 NEW)
endif ()
if (POLICY CMP0076)
  cmake_policy(SET CMP0076 NEW)
endif ()
if (POLICY CMP0079)
  cmake_policy(SET CMP0079 NEW)
endif ()
# cmake version 3.14 or later
if (POLICY CMP0090)
  cmake_policy(SET CMP0090 NEW)
endif ()
if (POLICY CMP0092)
  cmake_policy(SET CMP0092 NEW)
endif ()
if (POLICY CMP0094)
  cmake_policy(SET CMP0094 NEW)
endif ()

project(gdal LANGUAGES C CXX)

# setup cmake modules paths
include(cmake4gdal/modules/init.cmake)

# cotire cmake speedup addon
include(cotire)

set(CMAKE_CONFIGURATION_TYPES "Debug;Release" CACHE STRING "Configs" FORCE)

# template files path
set(GDAL_CMAKE_TEMPLATE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake4gdal/template)

################################################################
# Custom global properties
define_property(GLOBAL PROPERTY GDAL_FORMATS
                BRIEF_DOCS "Builtin format"
                FULL_DOCS "Builtin format"
                )
define_property(GLOBAL PROPERTY OGR_FORMATS
                BRIEF_DOCS "Builtin ogr drivers"
                FULL_DOCS "Builtin ogr drivers"
                )
define_property(GLOBAL PROPERTY PLUGIN_MODULES
                BRIEF_DOCS "Plugin modules"
                FULL_DOCS "Plugin modules"
                )
define_property(TARGET PROPERTY PLUGIN_OUTPUT_DIR
                BRIEF_DOCS "Plugin modules build directories"
                FULL_DOCS "Plugin modules build directories"
                )

################################################################
# check compiler and set preferences.
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

if (CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wno-unused-command-line-argument)
endif ()

if(CMAKE_CXX_COMPILER_ID MATCHES "AppleClang")
    if(NOT (CMAKE_CXX_COMPILER_VERSION VERSION_LESS "6.2"))
        SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++17")
    endif()
    if(NOT (CMAKE_CXX_COMPILER_VERSION VERSION_LESS "6.1"))
        SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14")
    endif()
    if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS "6.1" AND (NOT (CMAKE_CXX_COMPILER_VERSION VERSION_LESS "4.3")))
        SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++1y")
    endif()
    if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS "4.3")
        message(FATAL_ERROR "Building with a Apple clang version less than 4.3 is not supported.")
    endif()
elseif(CMAKE_CXX_COMPILER_ID MATCHES "Clang" AND NOT CMAKE_CXX_SIMULATE_ID MATCHES "MSVC") # clang, but not clang-cl.
    # non-Apple clangs uses different versioning.
    if(NOT (CMAKE_CXX_COMPILER_VERSION VERSION_LESS "5.0.0"))
        SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++17")
    endif()
    if(NOT (CMAKE_CXX_COMPILER_VERSION VERSION_LESS "3.5.0"))
        SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14")
    endif()
    if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS "3.5.0" AND (NOT (CMAKE_CXX_COMPILER_VERSION VERSION_LESS "3.2")))
        SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++1y")
    endif()
    if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS "3.2")
        message(FATAL_ERROR "Building with a clang version less than 3.2 is not supported.")
    endif()
elseif(CMAKE_CXX_COMPILER_ID MATCHES "GNU")
    if(NOT (CMAKE_CXX_COMPILER_VERSION VERSION_LESS "7.0.0"))
        SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++17")
    endif()
    if(NOT (CMAKE_CXX_COMPILER_VERSION VERSION_LESS "5.2.0"))
        SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14")
    endif()
    if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS "5.2.0" AND (NOT (CMAKE_CXX_COMPILER_VERSION VERSION_LESS "4.8.1")))
        SET(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++1y")
    endif()
    if(CMAKE_CXX_COMPILER_VERSION VERSION_LESS "4.8.1")
        message(FATAL_ERROR "Building with a gcc version less than 4.8.1 is not supported.")
    endif()
elseif(CMAKE_CXX_COMPILER_ID MATCHES "MSVC")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /std:c++latest /W4 /permissive-")
endif()

if (MSVC)
  set(CMAKE_DEBUG_POSTFIX "d")
  add_definitions(-D_CRT_SECURE_NO_DEPRECATE -D_CRT_NONSTDC_NO_DEPRECATE)
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS}  -wd4127 -wd4251 -wd4275 -wd4786 -wd4100 -wd4245 -wd4206 -wd4018 -wd4389")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -wd4127 -wd4251 -wd4275 -wd4786 -wd4100 -wd4245 -wd4206 -wd4018 -wd4389")
  add_definitions(-DNOMINMAX)
endif ()

include(CheckCompilerMachineOption)
include(CheckCompilerSIMDFeature)

if ("${CMAKE_SYSTEM_PROCESSOR}" MATCHES "(x86|AMD64)")
  set(ARCH_FLAG)
  check_compiler_machine_option(flag SSE)
  list(APPEND ARCH_FLAG ${flag})
  check_compiler_machine_option(flag SSSE3)
  list(APPEND ARCH_FLAG ${flag})
  check_compiler_machine_option(flag AVX)
  list(APPEND ARCH_FLAG ${flag})

  check_compiler_simd_feature(RESULT res FLAG ${ARCH_FLAG} QUERY HAVE_SSE)
  set(HAVE_SSE_AT_COMPILE_TIME ${res})
  check_compiler_simd_feature(RESULT res FLAG ${ARCH_FLAG} QUERY HAVE_SSSE3)
  set(HAVE_SSSE3_AT_COMPILE_TIME ${res})
  check_compiler_simd_feature(RESULT res FLAG ${ARCH_FLAG} QUERY HAVE_AVX)
  set(HAVE_AVX_AT_COMPILE_TIME ${res})
endif ()

################################################################
option(CLANG_TIDY_ENABLED "Run clang-tidy with the compiler." OFF)
set(CLANG_TIDY_CHECKS "-*,clang-analyzer-alpha.unix.cstring.*" CACHE STRING "clang-tidy checks")
set(CLANG_TIDY_WARNINGS_AS_ERRORS "clang-analyzer-alpha.unix.cstring.*" CACHE STRING "clang-tidy warnings as errors.")
if (RUN_CLANG_TIDY)
  if (CMAKE_SOURCE_DIR STREQUAL CMAKE_BINARY_DIR)
    message(FATAL_ERROR "RUN_CLANG_TIDY requires an out-of-source build!")
  endif ()
  find_program(CLANG_TIDY_COMMAND NAMES clang-tidy)
  if (NOT CLANG_TIDY_COMMAND)
    message(WARNING "RUN_CLANG_TIDY is ON but clang-tidy is not found!")
    set(CMAKE_CXX_CLANG_TIDY "" CACHE STRING "" FORCE)
  else ()
    set(CMAKE_CXX_CLANG_TIDY "${CLANG_TIDY_COMMAND};-checks='${CLANG_TIDY_CHECKS}';-header-filter='${CMAKE_SOURCE_DIR}/gdal/*';-warnings-as-errors='${CLANG_TIDY_WARNINGS_AS_ERRORS}'")
  endif ()
endif ()

################################################################
# Developer may want to specify some variable to find proper version
#  Priority is as same order as follows:
# 1. `Python_LOOKUP_VERSION`: specify minimum version to find.
# 2. 'Python_FIND_VIRTUALENV': specify 'ONLY' to use virtualenv activated.
# 3. `Python_ROOT`: specify installed location
# 4. If nothing specified, use default behavior.
#
# for example
#   $ cmake -DPython_LOOKUP_VERSION=3.6 ..
#   $ cmake -DPython_FIND_VIRTUALENV=ONLY ..
#   $ cmake -DPython_ROOT=C:\Python36 ..
#
if (Python_LOOKUP_VERSION)
    set(Python_FIND_STRATEGY VERSION)
    find_package(Python ${Python_LOOKUP_VERSION} COMPONENTS Interpreter Development NumPy)
else ()
    set(Python_FIND_STRATEGY LOCATION)
    find_package(Python COMPONENTS Interpreter Development NumPy)
endif ()

include(FeatureSummary)
set_package_properties(Python PROPERTIES PURPOSE "SWIG_PYTHON: Python binding")

################################################################
add_subdirectory(gdal)

# unit tests
add_subdirectory(autotest/cpp)

# please comment out if you want to exclude autotest from distribution.
add_subdirectory(autotest)

# Google OSS-Fuzz project utilities
add_subdirectory(gdal/fuzzers)
# Google OSS-Fuzz tests
add_subdirectory(gdal/fuzzers/tests)

# vim: ts=4 sw=4 sts=4 et
