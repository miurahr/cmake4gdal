
set(GDAL_SWIG_COMMON_INTERFACE_FILES
    ${CMAKE_CURRENT_SOURCE_DIR}/include/Band.i
    ${CMAKE_CURRENT_SOURCE_DIR}/include/ColorTable.i
    ${CMAKE_CURRENT_SOURCE_DIR}/include/cpl.i
    ${CMAKE_CURRENT_SOURCE_DIR}/include/cpl_exceptions.i
    ${CMAKE_CURRENT_SOURCE_DIR}/include/cplvirtualmem.i
    ${CMAKE_CURRENT_SOURCE_DIR}/include/Dataset.i
    ${CMAKE_CURRENT_SOURCE_DIR}/include/Driver.i
    ${CMAKE_CURRENT_SOURCE_DIR}/include/gdal.i
    ${CMAKE_CURRENT_SOURCE_DIR}/include/gdal_array.i
    ${CMAKE_CURRENT_SOURCE_DIR}/include/gdal_typemaps.i
    ${CMAKE_CURRENT_SOURCE_DIR}/include/gnm.i
    ${CMAKE_CURRENT_SOURCE_DIR}/include/MajorObject.i
    ${CMAKE_CURRENT_SOURCE_DIR}/include/ogr.i
    ${CMAKE_CURRENT_SOURCE_DIR}/include/ogr_error_map.i
    ${CMAKE_CURRENT_SOURCE_DIR}/include/Operations.i
    ${CMAKE_CURRENT_SOURCE_DIR}/include/osr.i
    ${CMAKE_CURRENT_SOURCE_DIR}/include/RasterAttributeTable.i
    ${CMAKE_CURRENT_SOURCE_DIR}/include/Transform.i
    ${CMAKE_CURRENT_SOURCE_DIR}/include/XMLNode.i
    ${CMAKE_CURRENT_SOURCE_DIR}/include/MutiDimensional.i
    )

add_subdirectory(python)

include(CMakeDependentOption)
if (HAVE_JAVA)
    add_subdirectory(java)
endif ()
if (HAVE_PERL)
    add_subdirectory(perl)
endif ()
if (HAVE_CSHARP)
    add_subdirectory(csharp)
endif ()
