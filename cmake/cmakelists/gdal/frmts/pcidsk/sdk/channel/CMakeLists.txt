add_library(pcidsk_sdk_channel OBJECT
        cbandinterleavedchannel.cpp  cexternalchannel.h  cpixelinterleavedchannel.cpp  ctiledchannel.h
        cbandinterleavedchannel.h    cpcidskchannel.cpp  cpixelinterleavedchannel.h
        cexternalchannel.cpp         cpcidskchannel.h    ctiledchannel.cpp
        )
target_include_directories(pcidsk_sdk_channel PRIVATE
                           ${CMAKE_CURRENT_SOURCE_DIR}
                           $<TARGET_PROPERTY:pcidsk_sdk,SOURCE_DIR>
                           $<TARGET_PROPERTY:cpl,SOURCE_DIR>
                           $<TARGET_PROPERTY:cpl,BINARY_DIR>
                           )
target_sources(gdal PRIVATE $<TARGET_OBJECTS:pcidsk_sdk_channel>)
set_property(TARGET pcidsk_sdk_channel PROPERTY POSITION_INDEPENDENT_CODE ON)
