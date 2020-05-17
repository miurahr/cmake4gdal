add_library(
  liblerc STATIC
  CntZImage.cpp
  CntZImage.h
  BitMaskV1.cpp
  BitMaskV1.h
  BitStufferV1.cpp
  BitStufferV1.h
  DefinesV1.h
  Image.h
  TImage.hpp)
target_include_directories(liblerc PRIVATE $<TARGET_PROPERTY:cpl,SOURCE_DIR> $<TARGET_PROPERTY:cpl,BINARY_DIR>)
set_property(TARGET liblerc PROPERTY POSITION_INDEPENDENT_CODE ON)
set_property(TARGET liblerc PROPERTY ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})
target_link_libraries(GDAL_LINK_LIBRARY INTERFACE liblerc)
