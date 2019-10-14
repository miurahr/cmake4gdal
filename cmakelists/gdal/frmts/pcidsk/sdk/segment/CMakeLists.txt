add_library(pcidsk_sdk_segment OBJECT
        cpcidsk_array.cpp            cpcidskgcp2segment.cpp    cpcidskvectorsegment.h
        cpcidsk_array.h              cpcidskgcp2segment.h      cpcidskvectorsegment_consistencycheck.cpp
        cpcidsk_tex.cpp              cpcidskgeoref.cpp         metadatasegment.h
        cpcidsk_tex.h                cpcidskgeoref.h           metadatasegment_p.cpp
        cpcidskads40model.cpp        cpcidskpct.cpp            orbitstructures.h
        cpcidskads40model.h          cpcidskpct.h              pcidsksegmentbuilder.h
        cpcidskapmodel.cpp           cpcidskpolymodel.h        sysblockmap.cpp
        cpcidskapmodel.h             cpcidskrpcmodel.cpp       sysblockmap.h
        cpcidskbinarysegment.cpp     cpcidskrpcmodel.h         toutinstructures.h
        cpcidskbinarysegment.h       cpcidsksegment.cpp        vecsegdataindex.cpp
        cpcidskbitmap.cpp            cpcidsksegment.h          vecsegdataindex.h
        cpcidskbitmap.h              cpcidsktoutinmodel.cpp    vecsegheader.cpp
        cpcidskephemerissegment.cpp  cpcidsktoutinmodel.h      vecsegheader.h
        cpcidskephemerissegment.h    cpcidskvectorsegment.cpp
        )
target_include_directories(pcidsk_sdk_segment PRIVATE
						   ${CMAKE_CURRENT_SOURCE_DIR}
						   $<TARGET_PROPERTY:pcidsk_sdk,SOURCE_DIR>
						   $<TARGET_PROPERTY:cpl,SOURCE_DIR>
						   $<TARGET_PROPERTY:cpl,BINARY_DIR>
						   )
target_sources(gdal PRIVATE $<TARGET_OBJECTS:pcidsk_sdk_segment>)
set_property(TARGET pcidsk_sdk_segment PROPERTY POSITION_INDEPENDENT_CODE ON)
