add_gdal_driver(
  TARGET gdal_KEA
  SOURCES keaband.cpp
          keaband.h
          keacopy.cpp
          keacopy.h
          keadataset.cpp
          keadataset.h
          keadriver.cpp
          keamaskband.cpp
          keamaskband.h
          keaoverview.cpp
          keaoverview.h
          kearat.cpp
          kearat.h
          libkea_headers.h
  PLUGIN)
gdal_standard_includes(gdal_KEA)
target_compile_definitions(gdal_KEA PRIVATE -DDO_NOT_USE_DEBUG_BOOL)
target_include_directories(gdal_KEA PRIVATE ${HDF5_INCLUDE_DIRS})
gdal_target_link_libraries(TARGET gdal_KEA LIBRARIES KEA::KEA ${HDF5_LIBRARIES})
