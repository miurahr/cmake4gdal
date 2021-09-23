add_gdal_driver(TARGET gdal_Zarr SOURCES zarr_array.cpp zarr_attribute.cpp zarr_group.cpp zarrdriver.cpp)
gdal_standard_includes(gdal_Zarr)
target_include_directories(
  gdal_Zarr PRIVATE $<TARGET_PROPERTY:gdal_MEM,SOURCE_DIR> $<TARGET_PROPERTY:gdal_GTIFF,SOURCE_DIR>
                    $<TARGET_PROPERTY:gdal_netCDF,SOURCE_DIR>)
