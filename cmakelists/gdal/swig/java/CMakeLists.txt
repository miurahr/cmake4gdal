# ******************************************************************************
# * Project:  CMake4GDAL
# * Purpose:  CMake build scripts
# * Author: Dmitriy Baryshnikov (aka Bishop), polimax@mail.ru, *                       Hiroshi Miura <miurahr@linux.com>
# ******************************************************************************
# * Copyright (C) 2017,2018 Hiroshi Miura *
# * Permission is hereby granted, free of charge, to any person obtaining a
# * copy of this software and associated documentation files (the "Software"),
# * to deal in the Software without restriction, including without limitation
# * the rights to use, copy, modify, merge, publish, distribute, sublicense,
# * and/or sell copies of the Software, and to permit persons to whom the
# * Software is furnished to do so, subject to the following conditions: *
# * The above copyright notice and this permission notice shall be included
# * in all copies or substantial portions of the Software. *
# * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
# * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# * DEALINGS IN THE SOFTWARE.
# ******************************************************************************

find_package(SWIG REQUIRED)
find_package(JNI REQUIRED)

include(GdalStandardIncludes)
function (GDAL_JAVA_WRAP)
  set(_options CXX)
  set(_oneValueArgs TARGET)
  set(_multiValueArgs ARGS)
  cmake_parse_arguments(_SWIG "${_options}" "${_oneValueArgs}" "${_multiValueArgs}" ${ARGN})
  if (_SWIG_CXX)
    set(SWIG_OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/org/gdal/${_SWIG_TARGET}/${_SWIG_TARGET}_wrap.cpp)
    add_custom_command(
      OUTPUT ${SWIG_OUTPUT}
      COMMAND ${SWIG_EXECUTABLE} ${_SWIG_ARGS} ${SWIG_DEFINES} -I${CMAKE_SOURCE_DIR}/gdal -I${CMAKE_SOURCE_DIR}/gdal -c++
              -java -o ${SWIG_OUTPUT} ${CMAKE_SOURCE_DIR}/gdal/swig/include/${_SWIG_TARGET}.i
      WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
      DEPENDS ${GDAL_SWIG_COMMON_INTERFACE_FILES} ${CMAKE_SOURCE_DIR}/gdal/swig/include/java/typemaps_java.i
              ${CMAKE_SOURCE_DIR}/gdal/swig/include/java/${_SWIG_TARGET}_java.i)
    set_source_files_properties(${SWIG_OUTPUT} PROPERTIES GENERATED 1)
    add_library(${_SWIG_TARGET}jni MODULE ${CMAKE_CURRENT_BINARY_DIR}/org/gdal/${_SWIG_TARGET}/${_SWIG_TARGET}_wrap.cpp)
  else ()
    set(SWIG_OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/org/gdal/${_SWIG_TARGET}/${_SWIG_TARGET}_wrap.c)
    add_custom_command(
      OUTPUT ${SWIG_OUTPUT}
      COMMAND ${SWIG_EXECUTABLE} ${_SWIG_ARGS} ${SWIG_DEFINES} -I${CMAKE_SOURCE_DIR}/gdal -java -o ${SWIG_OUTPUT}
              ${CMAKE_SOURCE_DIR}/gdal/swig/include/${_SWIG_TARGET}.i
      WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
      DEPENDS ${GDAL_SWIG_COMMON_INTERFACE_FILES} ${CMAKE_SOURCE_DIR}/gdal/swig/include/java/typemaps_java.i
              ${CMAKE_SOURCE_DIR}/gdal/swig/include/java/${_SWIG_TARGET}_java.i)
    set_source_files_properties(${SWIG_OUTPUT} PROPERTIES GENERATED 1)
    add_library(${_SWIG_TARGET}jni MODULE ${CMAKE_CURRENT_BINARY_DIR}/org/gdal/${_SWIG_TARGET}/${_SWIG_TARGET}_wrap.c)
  endif ()
  gdal_standard_includes(${_SWIG_TARGET}jni)
  target_include_directories(${_SWIG_TARGET}jni PRIVATE ${JNI_INCLUDE_DIRS} $<TARGET_PROPERTY:gnm,SOURCE_DIR>
                                                        ${CMAKE_CURRENT_BINARY_DIR})
endfunction ()

file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/org/gdal)
file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/org/gdal/gdalconst)
gdal_java_wrap(
  TARGET
  gdalconst
  ARGS
  -Wall
  -I${CMAKE_SOURCE_DIR}/gdal/swig/include
  -I${CMAKE_SOURCE_DIR}/gdal/swig/include/java
  -outdir
  ${CMAKE_CURRENT_BINARY_DIR}/org/gdal/gdalconst/
  -package
  "org.gdal.gdalconst")
foreach (tgt IN ITEMS gdal ogr osr gnm)
  file(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/org/gdal/${tgt})
  gdal_java_wrap(
    TARGET
    ${tgt}
    CXX
    ARGS
    -Wall
    -I${CMAKE_SOURCE_DIR}/gdal/swig/include
    -I${CMAKE_SOURCE_DIR}/gdal/swig/include/java
    -outdir
    ${CMAKE_CURRENT_BINARY_DIR}/org/gdal/${tgt}/
    -package
    "org.gdal.${tgt}")
endforeach ()

add_custom_target(java_binding ALL DEPENDS gdaljni ogrjni osrjni gnmjni gdalconstjni)
