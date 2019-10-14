#!/bin/sh

set -e

brew update
brew outdated
brew install freexl libxml2 libspatialite geos proj libpng openjpeg giflib jpeg szip postgresql postgis openssl poppler
brew install ccache swig
