# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file COPYING-CMAKE-SCRIPTS or https://cmake.org/licensing for details.

#.rst
# FindSQLITE3
# -----------
#
# - Try to find Sqlite3
# Once done this will define
#
#  SQLITE3_FOUND - system has Sqlite3
#  SQLITE3_INCLUDE_DIRS - the Sqlite3 include directory
#  SQLITE3_LIBRARIES - Link these to use Sqlite3
#
#  Copyright (c) 2008 Andreas Schneider <mail@cynapses.org>
#  Copyright (c) 2016, NextGIS <info@nextgis.com>
#  Copyright (c) 2018, Hiroshi Miura
#

if(SQLITE3_INCLUDE_DIR AND SQLITE3_LIBRARY)
  set(SQLITE3_FIND_QUIETLY TRUE)
endif()

find_package(PkgConfig QUIET)
if(PKG_CONFIG_FOUND)
    pkg_check_modules(PC_SQLITE3 QUIET sqlite3)
    set(SQLITE3_VERSION_STRING ${PC_SQLITE3_VERSION} CACHE INTERNAL "")
endif()

find_path(SQLITE3_INCLUDE_DIR
          NAMES  sqlite3.h
          HINTS ${PC_SQLITE3_INCLUDE_DIRS}
                ${SQLITE3_ROOT})

find_library(SQLITE3_LIBRARY
             NAMES sqlite3 sqlite3_i
             HINTS ${PC_SQLITE3_LIBRARY_DIRS}
                   ${SQLITE3_ROOT})
if(SQLITE3_INCLUDE_DIR AND SQLITE3_LIBRARY)
    get_filename_component(SQLITE3_LIBRARY_DIR ${SQLITE3_LIBRARY} DIRECTORY)
    find_path(SQLITE3_PCRE_LIBRARY
              NAMES pcre.${CMAKE_SHARED_LIBRARY_SUFFIX}
              SUFFIX_PATHS sqlite3
              PATHS /usr/lib
              HINTS ${SQLITE3_LIBRARY_DIR})
    if(EXISTS ${SQLITE3_PCRE_LIBRARY})
        set(SQLITE_HAS_PCRE ON CACHE BOOL "")
    else()
        set(SQLITE_HAS_PCRE OFF CACHE BOOL "")
    endif()
    # check column metadata
    set(SQLITE_COL_TEST_CODE "#ifdef __cplusplus
extern \"C\"
#endif
char sqlite3_column_table_name ();
int
main ()
{
return sqlite3_column_table_name ();
  return 0;
}
")
    check_c_source_compiles("${SQLITE_COL_TEST_CODE}"  SQLITE_HAS_COLUMN_METADATA)
    set(SQLITE_HAS_COLUMN_METADATA ${SQLITE_HAS_COLUMN_METADATA} CACHE BOOL "SQLite has column metadata.")
endif()
mark_as_advanced(SQLITE3_LIBRARY SQLITE3_INCLUDE_DIR SQLITE_HAS_PCRE SQLITE_HAS_COLUMN_METADATA)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(SQLite3
                                  FOUND_VAR SQLITE3_FOUND
                                  REQUIRED_VARS SQLITE3_LIBRARY SQLITE3_INCLUDE_DIR
                                  VERSION_VAR SQLITE3_VERSION_STRING)

if(SQLITE3_FOUND)
  set(SQLITE3_LIBRARIES ${SQLITE3_LIBRARY})
  set(SQLITE3_INCLUDE_DIRS ${SQLITE3_INCLUDE_DIR})
  if(NOT TARGET SQLITE3::SQLITE3)
    add_library(SQLITE3::SQLITE3 UNKNOWN IMPORTED)
    set_target_properties(SQLITE3::SQLITE3 PROPERTIES
                          INTERFACE_INCLUDE_DIRECTORIES "${SQLITE3_INCLUDE_DIRS}"
                          IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
                          IMPORTED_LOCATION "${SQLITE3_LIBRARY}")
    if(SQLITE_HAS_PCRE)
        set_property(TARGET SQLITE3::SQLITE3 APPEND PROPERTY
                     INTERFACE_COMPILE_DEFINITIONS "SQLITE_HAS_PCRE")
    endif()
    if(SQLITE_HAS_COLUMN_METADATA)
        set_property(TARGET SQLITE3::SQLITE3 APPEND PROPERTY
                     INTERFACE_COMPILE_DEFINITIONS "SQLITE_HAS_COLUMN_METADATA")
    endif()
  endif()
endif()