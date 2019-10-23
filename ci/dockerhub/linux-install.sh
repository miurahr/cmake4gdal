#!/bin/bash

set -e

export TZ=Europe/London
ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime
echo ${TZ} > /etc/timezone

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get -y -q install software-properties-common apt-transport-https curl
add-apt-repository -y ppa:ubuntugis/ubuntugis-unstable
add-apt-repository -y ppa:ubuntu-toolchain-r/test
curl https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -

if [ $(lsb_release -sc) = "bionic" ]; then
  add-apt-repository -y 'deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic-8 main'
  add-apt-repository -y ppa:miurahr/gdal-depends-experimental
  apt-get update
  apt-get install -y -q bison libjpeg-dev libgif-dev liblzma-dev libgeos-dev git \
     libcurl4-gnutls-dev libproj-dev libxml2-dev  libxerces-c-dev libnetcdf-dev netcdf-bin \
     libpoppler-dev libpoppler-private-dev gpsbabel libhdf4-alt-dev libhdf5-serial-dev libpodofo-dev poppler-utils \
     libfreexl-dev unixodbc-dev libwebp-dev libepsilon-dev liblcms2-2 libcrypto++-dev libdap-dev libkml-dev \
     libmysqlclient-dev libarmadillo-dev wget libfyba-dev libjsoncpp-dev libexpat1-dev \
     libclc-dev ocl-icd-opencl-dev libsqlite3-dev sqlite3-pcre libpcre3-dev libspatialite-dev libsfcgal-dev fossil libcairo2-dev libjson-c-dev \
     python3-dev libpython3-dev libpython3.6-dev python3.6-dev python3-numpy python3-lxml pyflakes python3-setuptools python3-pip python3-venv \
     python3-pytest cmake ninja-build swig doxygen texlive-latex-base make cppcheck ccache g++ \
     clang-8 clang-tools-8 clang-8-doc libclang-common-8-dev libclang-8-dev libclang1-8 clang-format-8 python-clang-8 libfuzzer-8-dev lldb-8 lld-8 \
     libpq-dev libpqtypes-dev postgresql-10 postgresql-client-10 postgresql-10-postgis-2.5 postgresql-10-postgis-scripts libgdal20
elif [ $(lsb_release -sc) = "xenial" ]; then
  add-apt-repository -y 'deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-8 main'
  apt-get update
  apt-get install -y -q libjpeg-dev libgif-dev liblzma-dev libgeos-dev git\
     libcurl4-gnutls-dev libproj-dev libxml2-dev  libxerces-c-dev libnetcdf-dev netcdf-bin \
     libpoppler-dev libpoppler-private-dev gpsbabel libhdf4-alt-dev libhdf5-serial-dev libpodofo-dev poppler-utils \
     libfreexl-dev unixodbc-dev libwebp-dev libepsilon-dev liblcms2-2 libcrypto++-dev libdap-dev libkml-dev \
     libmysqlclient-dev libogdi-dev libarmadillo-dev wget libfyba-dev libjsoncpp-dev libexpat1-dev \
     libclc-dev ocl-icd-opencl-dev libsqlite3-dev sqlite3-pcre libpcre3-dev libspatialite-dev libsfcgal-dev fossil libgeotiff-dev libcairo2-dev libjson-c-dev \
     python-dev python-numpy python-lxml pyflakes python-setuptools python-pip python-virtualenv \
     cmake ninja-build swig doxygen texlive-latex-base make cppcheck ccache g++ \
     clang-8 clang-tools-8 clang-8-doc libclang-common-8-dev libclang-8-dev libclang1-8 clang-format-8 python-clang-8 libfuzzer-8-dev lldb-8 lld-8 \
     libpq-dev postgresql-9.5 postgresql-client-9.5 postgresql-9.5-postgis-2.4 postgresql-9.5-postgis-scripts libgdal20
fi
