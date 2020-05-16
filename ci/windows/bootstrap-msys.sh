#! /bin/bash
pacman -S --noconfirm base-devel
pacman -S --noconfirm mingw64/mingw-w64-x86_64-toolchain
pacman -S --noconfirm mingw-w64-x86_64-proj mingw-w64-x86_64-geos mingw-w64-x86_64-hdf5 mingw-w64-x86_64-netcdf mingw-w64-x86_64-openjpeg mingw-w64-x86_64-poppler mingw-w64-x86_64-libtiff mingw-w64-x86_64-libpng mingw-w64-x86_64-xerces-c mingw-w64-x86_64-libxml2 mingw-w64-x86_64-libfreexl mingw-w64-x86_64-libgeotiff mingw-w64-x86_64-libspatialite mingw-w64-x86_64-libtiff mingw-w64-x86_64-pcre mingw-w64-x86_64-postgresql mingw-w64-x86_64-zstd mingw-w64-x86_64-crypto++ mingw-w64-x86_64-cgal mingw-w64-x86_64-jasper
pacman -S --noconfirm  mingw-w64-x86_64-python-numpy mingw-w64-x86_64-python-pytest mingw-w64-x86_64-cmake
python -m ensurepip --upgrade
python -m pip install -U wheel setuptools numpy
python -m pip install pytest pytest-sugar pytest-env