# CMake4GDAL project is distributed under X/MIT license. See accompanying file LICENSE.txt.

option(AUTOTEST_DOWNLOAD_TEST_DATA "Autotest to download test data" OFF)
option(AUTOTEST_SLOW_TEST "Autotest to run slow test" OFF)
if (NOT DEFINED ENV{CTEST_PARALLEL_LEVEL})
  set(PARALLEL_OPTION "-j1")
endif ()

if (Python_FOUND)
  if (WIN32)
    set(_SEP ";")
  else ()
    set(_SEP ":")
  endif ()
  get_target_property(PLUGIN_OUTPUT_DIR gdal PLUGIN_OUTPUT_DIR)
  list(APPEND _TEST_ENV "PATH=${CMAKE_BINARY_DIR}/gdal/apps${_SEP}$ENV{PATH}" "GDAL_DATA=${CMAKE_SOURCE_DIR}/gdal/data"
       "GDAL_DRIVER_PATH=${PLUGIN_OUTPUT_DIR}")
  if (GDAL_DOWNLOAD_TEST_DATA)
    list(APPEND _TEST_ENV GDAL_DOWNLOAD_TEST_DATA=YES)
  else ()
    list(APPEND _TEST_ENV GDAL_DOWNLOAD_TEST_DATA=NO)
  endif ()
  if (GDAL_SLOW_TESTS)
    list(APPEND _TEST_ENV GDAL_RUN_SLOW_TESTS=YES)
  else ()
    list(APPEND _TEST_ENV GDAL_RUN_SLOW_TESTS=NO)
  endif ()
  string(REPLACE ";" "\n  " TEST_ENV "${_TEST_ENV}")
  set(AUTOTEST_LOG_FILE "${CMAKE_CURRENT_BINARY_DIR}/autotest.log")
  configure_file(${GDAL_CMAKE_TEMPLATE_PATH}/pytest.ini.in ${CMAKE_CURRENT_BINARY_DIR}/pytest.ini @ONLY)
  file(COPY ${CMAKE_CURRENT_SOURCE_DIR}/conftest.py DESTINATION ${CMAKE_CURRENT_BINARY_DIR})

  set(PYTHON_RUN_ENV "PYTHONPATH=${CMAKE_BINARY_DIR}/gdal/swig/python/"
                     "LD_LIBRARY_PATH=${CMAKE_BINARY_DIR}/gdal${_SEP}$ENV{LD_LIBRARY_PATH}")
  if (UNIX OR CMAKE_VERSION VERSION_GREATER 3.13)
    foreach (
      tgt IN
      ITEMS ogr
            gcore
            gdrivers
            alg
            osr
            gnm
            pyscripts
            utilities)
      execute_process(COMMAND ${CMAKE_COMMAND} -E create_symlink ${CMAKE_CURRENT_SOURCE_DIR}/${tgt}
                              ${CMAKE_CURRENT_BINARY_DIR}/${tgt})
      add_custom_target(
        autotest_${tgt}
        COMMAND ${CMAKE_COMMAND} -E env ${PYTHON_RUN_ENV} ${Python_EXECUTABLE} -m pytest -c
                ${CMAKE_CURRENT_BINARY_DIR}/pytest.ini ${tgt}
        DEPENDS gdal gdalapps python_binding)
    endforeach ()
    add_custom_target(
      autotest
      COMMAND ${CMAKE_COMMAND} -E env ${PYTHON_RUN_ENV} ${Python_EXECUTABLE} -m pytest -c
              ${CMAKE_CURRENT_BINARY_DIR}/pytest.ini
      DEPENDS gdal gdalapps python_binding)
  else ()
    # Fall back to run test on source directory. FIXME: this breaks out-of-source build
    add_custom_target(
      autotest
      COMMAND ${CMAKE_COMMAND} -E env ${PYTHON_RUN_ENV} ${Python_EXECUTABLE} -m pytest -c
              ${CMAKE_CURRENT_BINARY_DIR}/pytest.ini
      WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/autotest)
  endif ()
  add_executable(pytest_runner ../cmake4gdal/pytest_runner.cpp)
  target_link_libraries(pytest_runner PRIVATE ${Python_LIBRARIES})
  target_include_directories(pytest_runner PRIVATE ${Python_INCLUDE_DIRS})
  add_custom_target(
    autotest_runner
    COMMAND ${CMAKE_COMMAND} -E env ${PYTHON_RUN_ENV} $<TARGET_NAME:pytest_runner> -c
            ${CMAKE_CURRENT_BINARY_DIR}/pytest.ini
    DEPENDS gdal gdalapps python_binding
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/autotest)
endif ()
