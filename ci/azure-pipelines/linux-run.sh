#!/usr/bin/env bash
#
# Environment variables:
#
# SOURCE_DIR: Set to the directory of the source
# BUILD_TYPE
# CC
# CXX

set -e

SOURCE_DIR=${SOURCE_DIR:-/src}
BUILD_DIR=${BUILD_DIR:-/build}
BUILD_TYPE=${BUILD_TYPE:-Debug}
CC=${CC:-gcc}
CXX=${CXX:-g++}

echo "Source directory: ${SOURCE_DIR}"
echo "Build directory:  ${BUILD_DIR}"
echo "Build type: ${BUILD_TYPE}"

cd ${BUILD_DIR}
git clone https://github.com/osgeo/gdal.git
ln -s ${SOURCE_DIR} ${BUILD_DIR}/gdal/cmake4gdal
python ${BUILD_DIR}/gdal/cmake4gdal/deploy.py
mkdir ${BUILD_DIR}/build
cd ${BUILD_DIR}/build
echo cmake -DCMAKE_BUILD_TYPE=Debug -DCMAKE_CXX_COMPILER_LAUNCHER=ccache -DCMAKE_C_COMPILER_LAUNCHER=ccache ${CMAKE_OPTIONS} ${BUILD_DIR}/gdal
cmake -DCMAKE_BUILD_TYPE=${BUILD_TYPE} -DCMAKE_CXX_COMPILER_LAUNCHER=ccache -DCMAKE_C_COMPILER_LAUNCHER=ccache ${CMAKE_OPTIONS} ${BUILD_DIR}/gdal
echo cmake --build . --target quicktest
cmake --build . --target quicktest
echo cmake --build . --target autotest
cmake --build . --target autotest
