add_library(pcidsk_sdk STATIC
    pcidsk.h pcidsk_ads40.h pcidsk_airphoto.h pcidsk_array.h
    pcidsk_binary.h pcidsk_buffer.h pcidsk_channel.h pcidsk_config.h
    pcidsk_edb.h pcidsk_ephemeris.h pcidsk_exception.h pcidsk_file.h
    pcidsk_gcp.h pcidsk_gcpsegment.h pcidsk_georef.h pcidsk_interfaces.h
    pcidsk_io.h pcidsk_mutex.h pcidsk_pct.h pcidsk_poly.h pcidsk_rpc.h
    pcidsk_segment.h pcidsk_shape.h pcidsk_tex.h pcidsk_toutin.h pcidsk_types.h
    pcidsk_vectorsegment.h
)
if(WIN32)
	target_sources(pcidsk_sdk PRIVATE port/io_win32.cpp port/win32_mutex.cpp)
else()
	target_sources(pcidsk_sdk PRIVATE port/io_stdio.cpp port/pthread_mutex.cpp)
endif()
target_include_directories(pcidsk_sdk PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}
						   $<TARGET_PROPERTY:cpl,SOURCE_DIR>
						   $<TARGET_PROPERTY:cpl,BINARY_DIR>
						   )
set_property(TARGET pcidsk_sdk PROPERTY POSITION_INDEPENDENT_CODE ON)

add_subdirectory(channel)
add_subdirectory(core)
add_subdirectory(segment)

if(NOT TARGET PCIDSK::PCIDSK)
    add_library(PCIDSK::PCIDSK UNKNOWN IMPORTED)
    set_target_properties(PCIDSK::PCIDSK PROPERTIES
                          INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_CURRENT_SOURCE_DIR})
endif()

target_link_libraries(GDAL_LINK_LIBRARY INTERFACE pcidsk_sdk)
