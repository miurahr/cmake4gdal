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


add_library(gcore_mdreader OBJECT
            reader_alos.h
            reader_digital_globe.h
            reader_eros.h
            reader_geo_eye.h
            reader_kompsat.h
            reader_landsat.h
            reader_orb_view.h
            reader_pleiades.h
            reader_rapid_eye.h
            reader_rdk1.h
            reader_spot.h
            reader_alos.cpp
            reader_digital_globe.cpp
            reader_eros.cpp
            reader_geo_eye.cpp
            reader_kompsat.cpp
            reader_landsat.cpp
            reader_orb_view.cpp
            reader_pleiades.cpp
            reader_rapid_eye.cpp
            reader_rdk1.cpp
            reader_spot.cpp
            )
gdal_standard_includes(gcore_mdreader)
target_include_directories(gcore_mdreader PRIVATE $<TARGET_PROPERTY:ogrsf_generic,SOURCE_DIR>)
target_sources(gdal PRIVATE $<TARGET_OBJECTS:gcore_mdreader>)
set_property(TARGET gcore_mdreader PROPERTY POSITION_INDEPENDENT_CODE ON)
if (CMAKE_VERSION VERSION_GREATER_EQUAL 3.16)
  set_property(SOURCE reader_pleiades.cpp reader_digital_globe.cpp reader_alos.cpp
               PROPERTY SKIP_UNITY_BUILD_INCLUSION ON)
endif()