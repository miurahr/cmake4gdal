# CMake4GDAL project is distributed under X/MIT license. See accompanying file LICENSE.txt.

enable_testing()
set(GDAL_ROOT_TEST_DIR "${CMAKE_SOURCE_DIR}/autotest")

if (NOT CMAKE_CROSSCOMPILING)
  if (LINUX)
    add_library(vsipreload MODULE ${CMAKE_SOURCE_DIR}/gdal/port/vsipreload.cpp)
    target_link_libraries(vsipreload PRIVATE $<TARGET_NAME:gdal>)
    if (CMAKE_VERSION VERSION_GREATER_EQUAL 3.16)
      set_property(SOURCE ${CMAKE_SOURCE_DIR}/gdal/port/vsipreload.cpp PROPERTY SKIP_UNITY_BUILD_INCLUSION ON)
    endif ()
  endif ()
endif ()

add_executable(
  gdal_unit_test
  tut/tut.hpp
  tut/tut_assert.hpp
  tut/tut_console_reporter.hpp
  tut/tut_exception.hpp
  tut/tut_gdal.h
  tut/tut_gdal.cpp
  tut/tut_posix.hpp
  tut/tut_reporter.hpp
  tut/tut_restartable.hpp
  tut/tut_result.hpp
  tut/tut_runner.hpp
  gdal_unit_test.cpp
  test_alg.cpp
  test_cpl.cpp
  test_gdal.cpp
  test_gdal_aaigrid.cpp
  test_gdal_dted.cpp
  test_gdal_gtiff.cpp
  test_ogr.cpp
  test_ogr_geos.cpp
  test_ogr_shape.cpp
  test_osr.cpp
  test_osr_pci.cpp
  test_osr_ct.cpp
  test_osr_proj4.cpp
  test_triangulation.cpp
  test_marching_squares_contour.cpp
  test_marching_squares_polygon.cpp
  test_marching_squares_square.cpp
  test_marching_squares_tile.cpp)
if (CMAKE_VERSION VERSION_GREATER_EQUAL 3.16)
  set_property(TARGET gdal_unit_test PROPERTY UNITY_BUILD OFF)
endif ()

target_link_libraries(gdal_unit_test PRIVATE $<TARGET_NAME:gdal> $<TARGET_NAME:cpl>)
add_dependencies(gdal_unit_test gdal)
gdal_standard_includes(gdal_unit_test)
target_compile_definitions(gdal_unit_test PRIVATE -DGDAL_TEST_ROOT_DIR="${GDAL_ROOT_TEST_DIR}")
target_include_directories(
  gdal_unit_test PRIVATE ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/tut $<TARGET_PROPERTY:appslib,SOURCE_DIR>
                         $<TARGET_PROPERTY:gdal_vrt,SOURCE_DIR>)
target_compile_definitions(gdal_unit_test PRIVATE -DGDAL_TEST_ROOT_DIR="${GDAL_ROOT_TEST_DIR}")
add_test(NAME test-unit COMMAND gdal_unit_test)
set(TEST_ENV)
if (MINGW)
  list(APPEND TEST_ENV SKIP_MEM_INTENSIVE_TEST=YES)
endif ()
list(APPEND TEST_ENV LD_LIBRARY_PATH=${CMAKE_BINARY_DIR}/gdal:$ENV{LD_LIBRARY_PATH}
     GDAL_DRIVER_PATH=${CMAKE_BINARY_DIR}/gdal/gdalplugins GDAL_DATA=${CMAKE_SOURCE_DIR}/gdal/data)
set_tests_properties(test-unit PROPERTIES ENVIRONMENT "${TEST_ENV}")

macro (gdal_test_target _target _source)
  add_executable(${_target} EXCLUDE_FROM_ALL ${_source})
  target_link_libraries(${_target} PRIVATE $<TARGET_NAME:gdal>)
  gdal_standard_includes(${_target})
  target_include_directories(${_target} PRIVATE $<TARGET_PROPERTY:appslib,SOURCE_DIR>)
  target_compile_definitions(${_target} PRIVATE -DGDAL_TEST_ROOT_DIR="${GDAL_ROOT_TEST_DIR}")
  add_dependencies(${_target} gdal)
endmacro ()

gdal_test_target(testblockcache testblockcache.cpp)
add_test(NAME test-block-cache-1 COMMAND testblockcache -check -co TILED=YES --debug TEST,LOCK -loops 3 --config
                                         GDAL_RB_LOCK_DEBUG_CONTENTION YES)
add_test(NAME test-block-cache-2 COMMAND testblockcache -check -co TILED=YES --debug TEST,LOCK -loops 3 --config
                                         GDAL_RB_LOCK_DEBUG_CONTENTION YES --config GDAL_RB_LOCK_TYPE SPIN)
add_test(NAME test-block-cache-3 COMMAND testblockcache -check -co TILED=YES -migrate)
add_test(NAME test-block-cache-4 COMMAND testblockcache -check -memdriver)
add_test(NAME test-block-cache-5 COMMAND testblockcache --config GDAL_BAND_BLOCK_CACHE HASHSET -check -co TILED=YES --debug
                                         TEST,LOCK -loops 3 --config GDAL_RB_LOCK_DEBUG_CONTENTION YES)
add_test(NAME test-block-cache-6
         COMMAND testblockcache --config GDAL_BAND_BLOCK_CACHE HASHSET -check -co TILED=YES --debug TEST,LOCK -loops 3
                 --config GDAL_RB_LOCK_DEBUG_CONTENTION YES --config GDAL_RB_LOCK_TYPE SPIN)

foreach (tgt IN ITEMS test-block-cache-1 test-block-cache-2 test-block-cache-3 test-block-cache-4 test-block-cache-5)
  set_tests_properties(${tgt} PROPERTIES ENVIRONMENT "${TEST_ENV}" WORKING_DIRECTORY ${GDAL_ROOT_TEST_DIR})
endforeach ()

gdal_test_target(testsse1 testsse.cpp)
target_compile_options(testsse1 PRIVATE ${GDAL_ARCH_FLAG})
gdal_test_target(testsse2 testsse.cpp)
gdal_test_target(testsse3 testsse.cpp)
gdal_test_target(testsse4 testsse.cpp)
gdal_test_target(testsse5 testsse.cpp)
target_compile_options(testsse2 PRIVATE -mssse3)
target_compile_options(testsse3 PRIVATE -mssse3 -msse4.1)
target_compile_options(testsse4 PRIVATE -mavx2)
target_compile_definitions(testsse5 PRIVATE -DUSE_SSE2_EMULATION)
add_test(NAME testsse1 COMMAND testsse1)
add_test(NAME testsse2 COMMAND testsse2)
add_test(NAME testsse3 COMMAND testsse3)
add_test(NAME testsse4 COMMAND testsse3)
add_test(NAME testsse5 COMMAND testsse3)
set_tests_properties(testsse1 PROPERTIES ENVIRONMENT "${TEST_ENV}" WORKING_DIRECTORY ${GDAL_ROOT_TEST_DIR})
set_tests_properties(testsse2 PROPERTIES ENVIRONMENT "${TEST_ENV}" WORKING_DIRECTORY ${GDAL_ROOT_TEST_DIR})
set_tests_properties(testsse3 PROPERTIES ENVIRONMENT "${TEST_ENV}" WORKING_DIRECTORY ${GDAL_ROOT_TEST_DIR})

macro (gdal_autotest_target _target testlabel _source options)
  if (NOT CMAKE_CROSSCOMPILING OR CMAKE_CROSSCOMPILING_EMULATOR)
    gdal_test_target(${_target} ${_source})
    add_test(NAME ${testlabel} COMMAND ${_target} ${options})
    set_tests_properties(${testlabel} PROPERTIES ENVIRONMENT "${TEST_ENV}")
  endif ()
endmacro ()

gdal_autotest_target(testcopywords test-copy-words testcopywords.cpp "")
gdal_autotest_target(testclosedondestroydm test-closed-on-destroy-DM testclosedondestroydm.cpp "")
gdal_autotest_target(testthreadcond test-threaded-condition testthreadcond.cpp "")
gdal_autotest_target(testvirtualmem test-virtual-memory testvirtualmem.cpp "")
gdal_autotest_target(testblockcachewrite test-block-cache-write testblockcachewrite.cpp "--debug ON")
gdal_autotest_target(testblockcachelimits test-block-cache-limit testblockcachelimits.cpp "--debug ON")
gdal_autotest_target(testmultithreadedwriting test-multi-threaded-writing testmultithreadedwriting.cpp "")
gdal_autotest_target(testdestroy test-destroy testdestroy.cpp "")
gdal_autotest_target(test_include_from_c_file testa-include-from-C-file test_include_from_c_file.c "")
gdal_autotest_target(test_c_include_from_cpp_file testa-C-include-from-CPP-file test_c_include_from_cpp_file.cpp "")
gdal_autotest_target(testperfcopywords testa-performance-copy-words testperfcopywords.cpp "")

get_property(_plugins GLOBAL PROPERTY PLUGIN_MODULES)
add_custom_target(
  quicktest
  COMMAND ${CMAKE_CTEST_COMMAND} --force-new-ctest-process --output-on-failure -R '^test-.*'
  DEPENDS gdal
          ${_plugins}
          gdal_unit_test
          testblockcache
          testcopywords
          testclosedondestroydm
          testthreadcond
          testvirtualmem
          testblockcachewrite
          testblockcachelimits
          testmultithreadedwriting
          testdestroy)
add_custom_target(
  test_misc
  COMMAND ${CMAKE_CTEST_COMMAND} ${PARALLEL_OPTION} --force-new-ctest-process --output-on-failure -R '^testa-.*'
  DEPENDS test_include_from_c_file test_c_include_from_cpp_file testperfcopywords)
add_custom_target(
  test_sse
  COMMAND ${CMAKE_CTEST_COMMAND} ${PARALLEL_OPTION} --force-new-ctest-process --output-on-failure -R '^testsse.*'
  DEPENDS testsse1 testsse2 testsse3 testsse4 testsse5)
