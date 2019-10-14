#!/usr/bin/env bash

set -e

SOURCE_DIR=${SOURCE_DIR:-/src}
BUILD_DIR=${BUILD_DIR:-/build}
BUILD_TYPE=${BUILD_TYPE:-Debug}

CC=${CC:-x86_64-w64-mingw32-gcc-posix}
CXX=${CXX:-x86_64-w64-mingw32-g++-posix}

cd ${BUILD_DIR}
cmake -DCMAKE_CXX_COMPILER=${CXX} -DCMAKE_C_COMPILER=${CC} -DCMAKE_VERBOSE_MAKEFILE=ON -DCMAKE_BUILD_TYPE=Debug -DCMAKE_TOOLCHAIN_FILE=${SOURCE_DIR}/cmake/platforms/mingw-w64-linux.toolchain.cmake -C${SOURCE_DIR}/cmake/configurations/mingw.cmake -DGDAL_USE_LIBTIFF_INTERNAL=ON -DSWIG_PYTHON=OFF ${SOURCE_DIR}
cmake --build . --target quicktest