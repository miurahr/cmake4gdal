add_library(
  pcidsk_sdk STATIC
  channel/cbandinterleavedchannel.cpp
  channel/cexternalchannel.cpp
  channel/cpcidskchannel.cpp
  channel/cpixelinterleavedchannel.cpp
  channel/ctiledchannel.cpp
  core/clinksegment.cpp
  core/cpcidskfile.cpp
  core/edb_pcidsk.cpp
  core/libjpeg_io.cpp
  core/metadataset_p.cpp
  core/pcidskbuffer.cpp
  core/pcidskcreate.cpp
  core/pcidskexception.cpp
  core/pcidskinterfaces.cpp
  core/pcidskopen.cpp
  core/pcidsk_pubutils.cpp
  core/pcidsk_utils.cpp
  core/sysvirtualfile.cpp
  port/io_stdio.cpp
  segment/cpcidsk_array.cpp
  segment/cpcidskbinarysegment.cpp
  segment/cpcidskephemerissegment.cpp
  segment/cpcidskgeoref.cpp
  segment/cpcidskpct.cpp
  segment/cpcidsksegment.cpp
  segment/cpcidskvectorsegment.cpp
  segment/cpcidskvectorsegment_consistencycheck.cpp
  segment/metadatasegment_p.cpp
  segment/cpcidskapmodel.cpp
  segment/cpcidskads40model.cpp
  segment/sysblockmap.cpp
  segment/cpcidskrpcmodel.cpp
  segment/cpcidsktoutinmodel.cpp
  segment/cpcidskgcp2segment.cpp
  segment/cpcidskbitmap.cpp
  segment/cpcidsk_tex.cpp
  segment/vecsegdataindex.cpp
  segment/vecsegheader.cpp)
if (WIN32)
  target_sources(pcidsk_sdk PRIVATE port/io_win32.cpp port/win32_mutex.cpp)
else ()
  target_sources(pcidsk_sdk PRIVATE port/io_stdio.cpp port/pthread_mutex.cpp)
endif ()
target_include_directories(pcidsk_sdk PRIVATE ${CMAKE_CURRENT_SOURCE_DIR} $<TARGET_PROPERTY:cpl,SOURCE_DIR>
                                              $<TARGET_PROPERTY:cpl,BINARY_DIR>)
set_property(TARGET pcidsk_sdk PROPERTY POSITION_INDEPENDENT_CODE ON)
set_property(TARGET pcidsk_sdk PROPERTY ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})

if (CMAKE_VERSION VERSION_GREATER_EQUAL 3.16)
  set_property(TARGET pcidsk_sdk PROPERTY UNITY_BUILD OFF)
endif ()

if (NOT TARGET PCIDSK::PCIDSK)
  add_library(PCIDSK::PCIDSK UNKNOWN IMPORTED)
  set_target_properties(PCIDSK::PCIDSK PROPERTIES INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_CURRENT_SOURCE_DIR})
endif ()

target_link_libraries(GDAL_LINK_LIBRARY INTERFACE pcidsk_sdk)
