add_gdal_driver(TARGET gdal_MSG
                SOURCES msgcommand.cpp msgcommand.h msgdataset.cpp msgdataset.h
                prologue.cpp prologue.h PublicDecompWT_all.cpp PublicDecompWT_headers.h
                reflectancecalculator.h reflectancecalculator.cpp xritheaderparser.cpp xritheaderparser.h)
gdal_standard_includes(gdal_MSG)
target_compile_definitions(gdal_MSG PRIVATE DEFINITIONS -DDO_NOT_USE_DEBUG_BOOL)
target_include_directories(gdal_MSG PRIVATE
                           "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/PublicDecompWT/DISE>"
                           "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/PublicDecompWT/COMP/WT/Inc>"
                           "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/PublicDecompWT/COMP/Inc>"
                           "$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>")
file(WRITE PublicDecompWT_all.h
	"// This is a generated file. Do not edit !
#if ((__GNUC__ > 4 || (__GNUC__ == 4 && __GNUC_MINOR__ >= 2)) && !defined(_MSC_VER))
#pragma GCC system_header
#endif
    ")
#
#for x in $(wildcard PublicDecompWT/COMP/WT/Src/*.cpp) $(wildcard PublicDecompWT/COMP/Src/*.cpp) $(wildcard PublicDecompWT/DISE/*.cpp) ; do\
#echo "#include \"$$x\"" >> PublicDecompWT_all.h; \
#done

