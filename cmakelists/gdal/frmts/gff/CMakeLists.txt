add_gdal_driver(TARGET gdal_GFF SOURCES gff_dataset.cpp)
gdal_standard_includes(gdal_GFF)
if (CMAKE_VERSION VERSION_GREATER_EQUAL 3.16)
  # These files has CPL_CVSID("$id$") which break ODR and UNITY_BUILD
  set_property(SOURCE gff_dataset.cpp PROPERTY SKIP_UNITY_BUILD_INCLUSION ON)
endif ()
