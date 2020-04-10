# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#.rst:
# FindCharLS - JPEG Loss-Less Open SOurce Library CharLS
# --------
#
# Find CharLS
#
# ::
#
#   CHARLS_INCLUDE_DIR, where to find charls.h, etc.
#   CHARLS_LIBRARIES, the libraries needed to use CharLS.
#   CHARLS_FOUND, If false, do not try to use CharLS.
#   CHARLS_VERSION, 1 if CharLS/interface.h exist and 2 if CharLS/charls.h exist
#

find_path(CHARLS_INCLUDE_DIR NAMES charls.h SUFFIX_PATHS CharLS)
find_path(CHARLS_INCLUDE_DIR NAMES interface.h SUFFIX_PATHS CharLS)

if(CHARLS_INCLUDE_DIR)
    if(EXISTS "${CHARLS_INCLUDE_DIR}/CharLS/interface.h")
        set(CHARLS_VERSION 1)
    else()
        set(CHARLS_VERSION 2)
    endif()
endif()

find_library(CHARLS_LIBRARY NAMES CharLS)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(CharLS
                                  FOUND_VAR CHARLS_FOUND
                                  REQUIRED_VARS CHARLS_LIBRARY CHARLS_INCLUDE_DIR
                                  VERSION_VAR CHARLS_VERSION)
mark_as_advanced(CHARLS_LIBRARY CHARLS_INCLUDE_DIR CHARLS_VERSION)

include(FeatureSummary)
set_package_properties(CHARLS PROPERTIES
                       DESCRIPTION "C++ JPEG Loss-Less Open SOurce Library Implementation."
                       URL "https://github.com/team-charls/charls"
)

if(CHARLS_FOUND)
    set(CHARLS_LIBRARIES ${CHARLS_LIBRARY})
    set(CHARLS_INCLUDE_DIRS ${CHARLS_INCLUDE_DIR})
    if(NOT TARGET CHARLS::CHARLS)
        add_library(CHARLS::CHARLS UNKNOWN IMPORTED)
        set_target_properties(CHARLS::CHARLS PROPERTIES
                              INTERFACE_INLUDE_DIRECTORIES ${CHARLS_INCLUDE_DIR}
                              IMPORTED_LINK_INTERFACE_LANGUAGES "C"
                              IMPORTED_LOCATION ${CHARLS_LIBRARY})
   endif()
endif()
