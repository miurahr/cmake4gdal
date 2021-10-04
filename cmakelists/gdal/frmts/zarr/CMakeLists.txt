add_gdal_driver(TARGET gdal_Zarr SOURCES zarr_array.cpp zarr_attribute.cpp zarr_group.cpp zarrdriver.cpp)
gdal_standard_includes(gdal_Zarr)
target_include_directories(gdal_Zarr PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/../mem ${CMAKE_CURRENT_SOURCE_DIR}/../gtiff
                                             ${CMAKE_CURRENT_SOURCE_DIR}/../netcdf})
