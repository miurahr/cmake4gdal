# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file COPYING-CMAKE-SCRIPTS or https://cmake.org/licensing for details.

#[=======================================================================[.rst:
FindGMP
--------

Find a GNU MP library.

IMPORTED Targets
^^^^^^^^^^^^^^^^

This module defines :prop_tgt:`IMPORTED` target ``GMP::GMP``, if found.

Result Variables
^^^^^^^^^^^^^^^^

``GMP_FOUND``
  true if GMP found.
``GMP_INCLUDE_DIRS``
  where to find gmp.h.
``GMP_LIBRARIES``
  libraries to use GMP.

#]=======================================================================]

find_path(GMP_INCLUDE_DIR gmp.h)
find_library(GMP_LIBRARY NAMES gmp)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(GMP FOUND_VAR GMP_FOUND REQUIRED_VARS GMP_LIBRARY GMP_INCLUDE_DIR)
mark_as_advanced(GMP_INCLUDE_DIR GMP_LIBRARY)

mark_as_advanced(GMP_INCLUDE_DIR GMP_LIBRARY)

if (GMP_INCLUDE_DIR AND GMP_LIBRARY)
  set(GMP_INCLUDE_DIRS "${GMP_INCLUDE_DIR}")
  set(GMP_LIBRARIES "${GMP_LIBRARY}")
  if(NOT TARGET GMP::GMP)
    add_library(GMP::GMP UNKNOWN IMPORTED)
    set_target_properties(GMP::GMP PROPERTIES
      INTERFACE_INCLUDE_DIRECTORIES ${GMP_INCLUDE_DIR})
    if (EXISTS "${GMP_LIBRARY}")
      set_target_properties(GMP::GMP PROPERTIES
        IMPORTED_LINK_INTERFACE_LANGUAGES "C"
        IMPORTED_LOCATION "${GMP_LIBRARY}")
    endif()
  endif()
endif()