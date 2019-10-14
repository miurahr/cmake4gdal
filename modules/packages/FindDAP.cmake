# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#.rst:
# Find DAP - Data Access Protocol library
# ~~~~~~~~~
#
# Copyright (c) 2017-2018, Hiroshi Miura <miurahr@linux.com>
#
# ::
#
# If it's found it sets DAP_FOUND to TRUE
# and following variables are set:
#    DAP_INCLUDE_DIR
#    DAP_LIBRARY
#    DAP_CLIENT_LIBRARY
#    DAP_SERVER_LIBRARY
#    DAP_VERSION
#

find_package(PkgConfig QUIET)
if(PKG_CONFIG_FOUND)
    pkg_check_modules(PC_DAP QUIET libdap)
endif()

find_path(DAP_INCLUDE_DIR NAMES DapObj.h
          HINTS ${PC_DAP_INCLUDE_DIRS})
find_library(DAP_LIBRARY NAMES dap
             HINTS ${PC_DAP_LIBRARY_DIRS})
find_library(DAP_CLIENT_LIBRARY NAMES dapclient
             HINTS ${PC_DAP_LIBRARY_DIRS})
find_library(DAP_SERVER_LIBRARY NAMES dapserver
             HINTS ${PC_DAP_LIBRARY_DIRS})
mark_as_advanced(DAP_INCLUDE_DIR DAP_LIBRARY DAP_CLIENT_LIBRARY DAP_SERVER_LIBRARY)

if(DAP_INCLUDE_DIR AND DAP_LIBRARY)
    set(DAP_CONFIG_EXE dap-config)
    execute_process(COMMAND ${DAP_CONFIG_EXE} --version
           OUTPUT_VARIABLE DAP_VERSION
           OUTPUT_STRIP_TRAILING_WHITESPACE
    )
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(DAP DEFAULT_MSG DAP_LIBRARY DAP_CLIENT_LIBRARY DAP_SERVER_LIBRARY DAP_INCLUDE_DIR)

if(DAP_FOUND)
    set(DAP_INCLUDE_DIRS ${DAP_INCLUDE_DIR})
    set(DAP_LIBRARIES ${DAP_LIBRARY} ${DAP_CLIENT_LIBRARY} ${DAP_SERVER_LIBRARY})

    if(NOT TARGET DAP::DAP)
        if(DAP_INCLUDE_DIR)
            add_library(DAP::DAP UNKNOWN IMPORTED)
            set_target_properties(DAP::DAP PROPERTIES
                                  INTERFACE_INCLUDE_DIRECTORIES ${DAP_INCLUDE_DIR})
            if(EXISTS "${DAP_LIBRARY}")
                set_target_properties(DAP::DAP PROPERTIES
                                      IMPORTED_LINK_INTERFACE_LANGUAGES "C"
                                      IMPORTED_LOCATION "${DAP_LIBRARY}")
            endif()
        endif()
        if(EXISTS "${DAP_CLIENT_LIBRARY}")
            add_library(DAP::CLIENT UNKNOWN IMPORTED)
            set_target_properties(DAP::CLIENT PROPERTIES
                                  IMPORTED_LINK_INTERFACE_LANGUAGES "C"
                                  IMPORTED_LOCATION "${DAP_CLIENT_LIBRARY}")
        endif()
        if(EXISTS "${DAP_SERVER_LIBRARY}")
            add_library(DAP::SERVER UNKNOWN IMPORTED)
            set_target_properties(DAP::SERVER PROPERTIES
                                  IMPORTED_LINK_INTERFACE_LANGUAGES "C"
                                  IMPORTED_LOCATION "${DAP_SERVER_LIBRARY}")
        endif()
    endif()
endif()
