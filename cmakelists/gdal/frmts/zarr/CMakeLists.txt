add_gdal_driver(TARGET gdal_Zarr SOURCES zarr_array.cpp zarr_attribute.cpp zarr_group.cpp zarrdriver.cpp)
gdal_standard_includes(gdal_Zarr)
target_include_directories(
  gdal_Zarr PRIVATE ${CMAKE_SOURCE_DIR}/gdal/frmts/mem ${CMAKE_SOURCE_DIR}/gdal/frmts/gtiff
                    ${CMAKE_SOURCE_DIR}/gdal/frmts/netcdf})
