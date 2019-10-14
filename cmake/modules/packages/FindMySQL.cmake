# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file COPYING-CMAKE-SCRIPTS or https://cmake.org/licensing for details.

#.rst
# Get from http://www.cmake.org/Wiki/CMakeUserFindMySQL
# - Find mysqlclient
# Find the native MySQL includes and library
#
#  MYSQL_INCLUDE_DIR - where to find mysql.h, etc.
#  MYSQL_LIBRARIES   - List of libraries when using MySQL.
#  MYSQL_FOUND       - True if MySQL found.

find_path(MYSQL_INCLUDE_DIR mysql.h PATH_SUFFIXES mysql)
set(MYSQL_NAMES mysqlclient mysqlclient_r)
find_library(MYSQL_LIBRARY NAMES ${MYSQL_NAMES})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(MYSQL
                                  FOUND_VAR MYSQL_FOUND
                                  REQUIRERD_VARS MYSQL_LIBRARY MYSQL_INCLUDE_DIR)
mark_as_advanced(MYSQL_LIBRARY MYSQL_INCLUDE_DIR)

if(MYSQL_FOUND)
  set(MYSQL_LIBRARIES ${MYSQL_LIBRARY})
  set(MYSQL_INCLUDE_DIRS ${MYSQL_INCLUDE_DIRS})
  if(NOT TARGET MYSQL::CLIENT)
      add_library(MYSQL::CLIENT UNKNOWN IMPORETED)
      set_target_properties(MYSQL::CLIENT PROPERTIES
                            INTERFACE_INCLUDE_DIRECTORIES ${MYSQL_INCLUDE_DIR}
                            IMPORTED_LINK_INTERFACE_LANGUAGES "C"
                            IMPORTED_LOCATION ${MYSQL_LIBRARY})
  endif()
endif()

