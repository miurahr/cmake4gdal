# SWIG generates wrapper sources
option(GDAL_SWIG_REGENERATE_PYTHON "Generate python source with SWIG." OFF)
if(GDAL_SWIG_REGENERATE_PYTHON)
    set(gdal_python_csource_dir "${CMAKE_CURRENT_BINARY_DIR}/extensions/")
    set(GDAL_PYTHON_CSOURCES
        ${gdal_python_csource_dir}/gdal_wrap.cpp
        ${gdal_python_csource_dir}/gdalconst_wrap.c
        ${gdal_python_csource_dir}/gnm_wrap.cpp
        ${gdal_python_csource_dir}/ogr_wrap.cpp
        ${gdal_python_csource_dir}/osr_wrap.cpp )
    set(GDAL_PYTHON_PYSOURCES
        ${CMAKE_CURRENT_BINARY_DIR}/osgeo/gdal.py
        ${CMAKE_CURRENT_BINARY_DIR}/osgeo/gdalconst.py
        ${CMAKE_CURRENT_BINARY_DIR}/osgeo/gdalnumeric.py
        ${CMAKE_CURRENT_BINARY_DIR}/osgeo/gnm.py
        ${CMAKE_CURRENT_BINARY_DIR}/osgeo/ogr.py
        ${CMAKE_CURRENT_BINARY_DIR}/osgeo/osr.py )
    include(GdalSwigBindings)
    if(Pyhton_VERSION_MAJOR EQUAL 3)
        set(PY3ARG "-py3")
    else()
        unset(PY3ARG)
    endif()
    gdal_swig_bindings(BINDING python ARGS -I${CMAKE_SOURCE_DIR}/gdal/swig/include/python/docs ${PY3ARG} -threads -outdir ${CMAKE_CURRENT_BINARY_DIR}
                       OUTPUT ${GDAL_PYTHON_PYSOURCES} ${GDAL_PYTHON_CSOURCES})

    # gdal_array_wrap.cpp when NumPy exist
    if(NumPy_FOUND)
        set(ARRAY_INPUT  ${CMAKE_SOURCE_DIR}/gdal/swig/include/gdal_array.i )
        set(ARRAY_OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/extensions/gdal_array_wrap.cpp )
        add_custom_command(OUTPUT  ${ARRAY_OUTPUT} "${CMAKE_CURRENT_BINARY_DIR}/osgeo/gdal_array.py"
                           COMMAND ${SWIG_EXECUTABLE}
                              -Wall  -I${CMAKE_SOURCE_DIR}/gdal/swig/include
                              -I${CMAKE_SOURCE_DIR}/gdal/swig/include/python -I${CMAKE_SOURCE_DIR}/gdal/swig/include/python/docs
                              ${PY3ARG} -threads -outdir ${CMAKE_CURRENT_BINARY_DIR}
                              ${SWIG_DEFINES} -I${CMAKE_SOURCE_DIR}/gdal -c++ -python -o ${ARRAY_OUTPUT} ${ARRAY_INPUT}
                           DEPENDS ${GDAL_SWIG_COMMON_INCLUDE} ${ARRAY_INPUT}
                              ${CMAKE_SOURCE_DIR}/gdal/swig/include/python/typemaps_python.i )
        list(APPEND GDAL_PYTHON_CSOURCES "${gdal_python_csource_dir}/gdal_array_wrap.cpp")
        list(APPEND GDAL_PYTHON_PYSOURCES "${CMAKE_CURRENT_BINARY_DIR}/osgeo/gdal_array.py")
    endif()
    add_custom_target(python_mod DEPENDS ${GDAL_PYTHON_PYSOURCES} ${GDAL_PYTHON_CSOURCES} )
else()
    set(gdal_python_csource_dir "${CMAKE_CURRENT_SOURCE_DIR}/extensions/")
    set(GDAL_PYTHON_PYSOURCES
        ${CMAKE_CURRENT_BINARY_DIR}/osgeo/gdal.py
        ${CMAKE_CURRENT_BINARY_DIR}/osgeo/gdalconst.py
        ${CMAKE_CURRENT_BINARY_DIR}/osgeo/gdalnumeric.py
        ${CMAKE_CURRENT_BINARY_DIR}/osgeo/gdal_array.py
        ${CMAKE_CURRENT_BINARY_DIR}/osgeo/gnm.py
        ${CMAKE_CURRENT_BINARY_DIR}/osgeo/ogr.py
        ${CMAKE_CURRENT_BINARY_DIR}/osgeo/osr.py )
    file(TO_NATIVE_PATH "${CMAKE_CURRENT_BINARY_DIR}/osgeo/" osgeo_binary_dir)
    file(TO_NATIVE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/osgeo/" osgeo_source_dir)
    if(Python_VERSION_MAJOR EQUAL 3 AND Python_EXECUTABLE)
        add_custom_target(python_mod
                          COMMAND ${CMAKE_COMMAND} -E make_directory ${osgeo_binary_dir}
                          COMMAND ${Python_EXECUTABLE} -m lib2to3
                               --fix=import --fix=next --fix=renames
                               --fix=unicode --fix=ws_comma --fix=xrange
                               --write --write-unchanged-files --nobackups
                               --output-dir=${osgeo_binary_dir}
                               ${osgeo_source_dir}__init__.py
                               ${osgeo_source_dir}gdal.py
                               ${osgeo_source_dir}gdalconst.py
                               ${osgeo_source_dir}gdalnumeric.py
                               ${osgeo_source_dir}ogr.py
                               ${osgeo_source_dir}osr.py
                               ${osgeo_source_dir}gnm.py
                               ${osgeo_source_dir}gdal_array.py
                          BYPRODUCTS ${GDAL_PYTHON_PYSOURCES} )
    else()
        add_custom_target(python_mod
                          COMMAND ${CMAKE_COMMAND} -E make_directory ${osgeo_binary_dir}
                          COMMAND ${CMAKE_COMMAND} -E copy
                               ${osgeo_source_dir}__init__.py
                               ${osgeo_source_dir}gdal.py
                               ${osgeo_source_dir}gdalconst.py
                               ${osgeo_source_dir}gdalnumeric.py
                               ${osgeo_source_dir}ogr.py
                               ${osgeo_source_dir}osr.py
                               ${osgeo_source_dir}gnm.py
                               ${osgeo_source_dir}gdal_array.py
                               ${osgeo_binary_dir}
                          BYPRODUCTS ${GDAL_PYTHON_PYSOURCES} )
    endif()
    set(GDAL_PYTHON_CSOURCES
        ${gdal_python_csource_dir}/gdal_wrap.cpp
        ${gdal_python_csource_dir}/gdalconst_wrap.c
        ${gdal_python_csource_dir}/gnm_wrap.cpp
        ${gdal_python_csource_dir}/ogr_wrap.cpp
        ${gdal_python_csource_dir}/osr_wrap.cpp )
 endif()

if(Python_EXECUTABLE)
    if(ENABLE_GNM)
        set(GNM_ENABLED "True")
    else()
        set(GNM_ENABLED "False")
    endif()
    file(TO_NATIVE_PATH "${gdal_python_csource_dir}" GDAL_PYTHON_EXT_SOURCE_DIR)
    configure_file(${GDAL_CMAKE_TEMPLATE_PATH}/setup.py.in ${CMAKE_CURRENT_BINARY_DIR}/setup.py @ONLY)
    # FIXME
    set(PY_EXT_EXT  "cpython-35m-x86_64-linux-gnu.so" )
    add_custom_target(python_ext COMMAND ${Python_EXECUTABLE} setup.py build_ext --inplace
                      WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
                      BYPRODUCTS
                       osgeo._gdal.${PY_EXT_EXT} osgeo._gdalconst.${PY_EXT_EXT} osgeo._gdal_array.${PY_EXT_EXT}
                       osgeo._gnm.${PY_EXT_EXT} osgeo._ogr.${PY_EXT_EXT} osgeo._osr.${PY_EXT_EXT}
                      SOURCES ${GDAL_PYTHON_PYSOURCDES} ${GDAL_PYTHON_CSOURCES})

    add_custom_target(python_binding ALL DEPENDS python_mod python_ext gdal)

    add_custom_target(python_wheel COMMAND ${Python_EXECUTABLE} setup.py bdist_wheel
                      WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} DEPENDS python_ext)
    add_custom_target(python_sdist COMMAND ${Python_EXECUTABLE} setup.py sdist
                      WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR} DEPENDS python_ext)
    add_custom_target(python_distribution DEPENDS python_wheel python_sdist)
    if(CMAKE_INSTALL_PREFIX)
        install(CODE "execute_process(COMMAND ${Python_EXECUTABLE} setup.py install --prefix=\"${CMAKE_INSTALL_PREFIX}\" WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})")
    else()
        install(CODE "execute_process(COMMAND ${Python_EXECUTABLE} setup.py install WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})")
    endif()
else()
    macro(py_ext name v source)
        set(GDAL_PYTHON_EXT_SOURCE_DIR "${gdal_python_csource_dir}")
        python_add_library(${name}${v} MODULE ${GDAL_PYTHON_EXT_SOURCE_DIR}/${source})
        set_target_properties(${name}${v} PROPERTIES  LIBRARY_OUTPUT_NAME ${name}
                              LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/osgeo)
        gdal_standard_includes(${name}${v})
        target_include_directories(${name}${v} PRIVATE $<TARGET_PROPERTY:appslib,SOURCE_DIR> $<TARGET_PROPERTY:gnm,SOURCE_DIR>)
        if(CMAKE_SYSTEM_NAME STREQUAL "Windows")
            target_compile_definitions(${name}${v} PRIVATE -D__MSVCRT_VERSION__=0x0601)
        endif()
        target_link_libraries(${name}${v} PRIVATE $<TARGET_NAME:gdal>)
        install(TARGETS ${name}${v} COMPONENT python DESTINATION ${Python_SITEARCH}/osgeo)
    endmacro()
    set(v ${Python_VERSION_MAJOR})
    py_ext(_gdal ${v} gdal_wrap.cpp)
    py_ext(_gdalconst ${v} gdalconst_wrap.c)
    py_ext(_gnm ${v} gnm_wrap.cpp)
    py_ext(_ogr ${v} ogr_wrap.cpp)
    py_ext(_osr ${v} osr_wrap.cpp)
    set(_py_depends)
    if(Python_NumPy_FOUND)
        if(NOT Pyhton_NumPy_VERSION VERSION_LESS 1.0.0)
          py_ext(_gdal_array ${v} gdal_array_wrap.cpp)
          target_include_directories(_gdal_array${v} PRIVATE ${Python_NumPy_INCLUDE_DIRS})
          list(APPEND _py_depends _gdal_array${v})
        endif()
    endif()
    if(ENABLE_GNM)
        list(APPEND _py_depends _gnm${v})
    endif()
    add_custom_target(python_ext_mod DEPENDS _gdal${v} _gdalconst${v} _ogr${v} _osr${v} ${_py_depends} )
    add_custom_target(python_binding ALL DEPENDS python_mod python_ext_mod)
    install(FILES
                ${CMAKE_CURRENT_BINARY_DIR}/osgeo/__init__.py
                ${CMAKE_CURRENT_BINARY_DIR}/osgeo/gdal.py
                ${CMAKE_CURRENT_BINARY_DIR}/osgeo/gdalconst.py
                ${CMAKE_CURRENT_BINARY_DIR}/osgeo/gdalnumeric.py
                ${CMAKE_CURRENT_BINARY_DIR}/osgeo/gnm.py
                ${CMAKE_CURRENT_BINARY_DIR}/osgeo/ogr.py
                ${CMAKE_CURRENT_BINARY_DIR}/osgeo/osr.py
            COMPONENT python
            DESTINATION ${Python_SITELIB}/osgeo)
endif()

add_subdirectory(scripts)

add_custom_command(OUTPUT ${CMAKE_SOURCE_DIR}/gdal/swig/include/python/docs/ogr_layer_docs.i
				   COMMAND ${Python_EXECUTABLE} ../include/python/docs/doxy2swig.py ../../xml/ogrlayer_8cpp.xml ../include/python/docs/ogr_layer_docs.i OGRLayerShadow OGR_L_
                   WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})

add_custom_command(OUTPUT ${CMAKE_SOURCE_DIR}/gdal/swig/include/python/docs/ogr_geometry_docs.i
				   COMMAND ${Python_EXECUTABLE} ../include/python/docs/doxy2swig.py ../../xml/ogrgeometry_8cpp.xml ../include/python/docs/ogr_geometry_docs.i OGRGeometryShadow OGR_G_
                   WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})

add_custom_command(OUTPUT ${CMAKE_SOURCE_DIR}/gdal/swig/include/python/docs/ogr_datasource_docs.i
				   COMMAND ${Python_EXECUTABLE} ../include/python/docs/doxy2swig.py ../../xml/ogrdatasource_8cpp.xml ../include/python/docs/ogr_datasource_docs.i OGRDataSourceShadow OGR_DS_
                   WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})

add_custom_command(OUTPUT ${CMAKE_SOURCE_DIR}/gdal/swig/include/python/docs/ogr_driver_docs.i
				   COMMAND ${Python_EXECUTABLE} ../include/python/docs/doxy2swig.py ../../xml/ogrsfdriver_8cpp.xml ../include/python/docs/ogr_driver_docs.i OGRDriverShadow OGR_Dr_
                   WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})

add_custom_command(OUTPUT ${CMAKE_SOURCE_DIR}/gdal/swig/include/python/docs/ogr_feature_docs.i
				   COMMAND ${Python_EXECUTABLE} ../include/python/docs/doxy2swig.py ../../xml/ogrfeature_8cpp.xml ../include/python/docs/ogr_feature_docs.i OGRFeatureShadow OGR_F_
                   WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})

add_custom_command(OUTPUT ${CMAKE_SOURCE_DIR}/gdal/swig/include/python/docs/ogr_featuredef_docs.i
				   COMMAND ${Python_EXECUTABLE} ../include/python/docs/doxy2swig.py ../../xml/ogrfeaturedefn_8cpp.xml ../include/python/docs/ogr_featuredef_docs.i OGRFeatureDefnShadow OGR_FD_
                   WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})

add_custom_command(OUTPUT ${CMAKE_SOURCE_DIR}/gdal/swig/include/python/docs/ogr_fielddef_docs.i
				   COMMAND ${Python_EXECUTABLE} ../include/python/docs/doxy2swig.py ../../xml/ogrfielddefn_8cpp.xml ../include/python/docs/ogr_fielddef_docs.i OGRFieldDefnShadow OGR_Fld_
                   WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})

add_custom_target(epydoc COMMAND epydoc --config epydoc.conf
                  WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})
