# ******************************************************************************
# * Project:  CMake4GDAL
# * Purpose:  CMake build scripts
# * Author: Hiroshi Miura, Dmitriy Baryshnikov (aka Bishop), polimax@mail.ru
# ******************************************************************************
# * Copyright (C) 2018 Hiroshi Miura
# * Copyright (C) 2012 Bishop
# *
# * Permission is hereby granted, free of charge, to any person obtaining a
# * copy of this software and associated documentation files (the "Software"),
# * to deal in the Software without restriction, including without limitation
# * the rights to use, copy, modify, merge, publish, distribute, sublicense,
# * and/or sell copies of the Software, and to permit persons to whom the
# * Software is furnished to do so, subject to the fo$<BUILD_INTERFACE:llowing conditions:
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

add_library(libjson STATIC
        arraylist.h
        bits.h
        config.h
        debug.h
        json.h
        json_c_version.h
        json_config.h
        json_inttypes.h
        json_object.h
        json_object_private.h
        json_tokener.h
        json_util.h
        linkhash.h
        json_object_iterator.h
        printbuf.h
        symbol_renames.h
        arraylist.c
        debug.c
        json_c_version.c
        json_object.c
        json_object_iterator.c
        json_tokener.c
        json_util.c
        linkhash.c
        printbuf.c
)
# -D_XOPEN_SOURCE=500 to enable strdup() definition in C11 mode
target_compile_definitions(libjson PRIVATE -D_XOPEN_SOURCE=500)
target_include_directories(libjson PRIVATE $<TARGET_PROPERTY:cpl,SOURCE_DIR> $<TARGET_PROPERTY:cpl,BINARY_DIR>)
set_target_properties(libjson PROPERTIES CXX_STANDARD 11)
set_property(TARGET libjson PROPERTY POSITION_INDEPENDENT_CODE ON)
target_link_libraries(GDAL_LINK_LIBRARY INTERFACE libjson)