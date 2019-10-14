add_library(pcidsk_sdk_core OBJECT
    clinksegment.cpp  edb_pcidsk.cpp     mutexholder.h        pcidskbuffer.cpp      pcidskopen.cpp
    clinksegment.h    libjpeg_io.cpp     pcidsk_pubutils.cpp  pcidskcreate.cpp      protectedfile.h
    cpcidskfile.cpp   metadataset.h      pcidsk_utils.cpp     pcidskexception.cpp   sysvirtualfile.cpp
    cpcidskfile.h     metadataset_p.cpp  pcidsk_utils.h       pcidskinterfaces.cpp  sysvirtualfile.h
)

target_include_directories(pcidsk_sdk_core PRIVATE
                           ${CMAKE_CURRENT_SOURCE_DIR}
                           $<TARGET_PROPERTY:pcidsk_sdk,SOURCE_DIR>
                           $<TARGET_PROPERTY:cpl,SOURCE_DIR>
                           $<TARGET_PROPERTY:cpl,BINARY_DIR>
                           )

if(GDAL_USE_LIBJPEG_INTERNAL)
	target_include_directories(pcidsk_sdk_core PRIVATE $<TARGET_PROPERTY:libjpeg,SOURCE_DIR>)
    target_compile_definitions(pcidsk_sdk_core PRIVATE -DHAVE_LIBJPEG)
else()
	target_include_directories(pcidsk_sdk_core PRIVATE ${JPEG_INCLUDE_DIRS})
    target_compile_definitions(pcidsk_sdk_core PRIVATE -DHAVE_LIBJPEG)
	target_link_libraries(GDAL_LINK_LIBRARY INTERFACE JPEG::JPEG)
endif()
target_sources(gdal PRIVATE $<TARGET_OBJECTS:pcidsk_sdk_core>)
set_property(TARGET pcidsk_sdk_core PROPERTY POSITION_INDEPENDENT_CODE ON)