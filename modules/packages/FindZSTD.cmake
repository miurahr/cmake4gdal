# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying file COPYING-CMAKE-SCRIPTS or
# https://cmake.org/licensing for details.

#[=======================================================================[.rst:
FindZSTD
--------

Find the ZSTD library

IMPORTED targets
^^^^^^^^^^^^^^^^

This module defines the following :prop_tgt:`IMPORTED` target: ``ZSTD::ZSTD``

Result variables
^^^^^^^^^^^^^^^^

This module will set the following variables if found:

``ZSTD_INCLUDE_DIRS`` - where to find zstd.h, etc.
``ZSTD_LIBRARIES`` - the libraries to link against to use ZSTD.
``ZSTD_VERSION`` - version of the ZSTD library found
``ZSTD_FOUND`` - TRUE if found

::

  ``ZSTD_VERSION_STRING`` - The version of zstd found (x.y.z)
  ``ZSTD_VERSION_MAJOR``  - The major version of zstd
  ``ZSTD_VERSION_MINOR``  - The minor version of zstd
  ``ZSTD_VERSION_PATCH``  - The release version of zstd

#]=======================================================================]

find_path(
  ZSTD_INCLUDE_DIR
  NAMES zstd.h
)
find_library(
  ZSTD_LIBRARY
  NAMES zstd
)

# Extract version information from the header file
if (ZSTD_INCLUDE_DIR)
  file(READ ${ZSTD_INCLUDE_DIR}/zstd.h _ver_line)
  string(REGEX REPLACE "^.*[ \t]+ZSTD_VERSION_MAJOR[ \t]+([0-9]+).*$" "\\1" ZSTD_VERSION_MAJOR "${_ver_line}")
  string(REGEX REPLACE "^.*[ \t]+ZSTD_VERSION_MINOR[ \t]+([0-9]+).*$" "\\1" ZSTD_VERSION_MINOR "${_ver_line}")
  string(REGEX REPLACE "^.*[ \t]+ZSTD_VERSION_RELEASE[ \t]+([0-9]+).*$" "\\1" ZSTD_VERSION_PATCH "${_ver_line}")
  unset(_ver_line)
  set(ZSTD_VERSION_STRING "${ZSTD_VERSION_MAJOR}.${ZSTD_VERSION_MINOR}.${ZSTD_VERSION_PATCH}")
endif ()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
  ZSTD
  FOUND_VAR ZSTD_FOUND
  REQUIRED_VARS ZSTD_LIBRARY ZSTD_INCLUDE_DIR
  VERSION_VAR ZSTD_VERSION_STRING
  HANDLE_COMPONENTS)
mark_as_advanced(ZSTD_INCLUDE_DIR ZSTD_LIBRARY)

include(FeatureSummary)
set_package_properties(
  ZSTD PROPERTIES
  DESCRIPTION "Zstandard - Fast real-time compression algorithm"
  URL "https://github.com/facebook/zstd")

if(ZSTD_FOUND)
  set(ZSTD_INCLUDE_DIRS ${ZSTD_INCLUDE_DIR})
  set(ZSTD_LIBRARIES ${ZSTD_LIBRARY})
  if(NOT TARGET ZSTD::ZSTD)
    add_library(ZSTD::ZSTD UNKNOWN IMPORTED)
    set_target_properties(ZSTD::ZSTD PROPERTIES INTERFACE_INCLUDE_DIRECTRIES ${ZSTD_INCLUDE_DIR})
    if(EXISTS "${ZSTD_LIBRARY}")
      set_target_properties(ZSTD::ZSTD PROPERTIES IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
        IMPORTED_LOCATION "${ZSTD_LIBRARY}")
    endif()
  endif()
endif()
