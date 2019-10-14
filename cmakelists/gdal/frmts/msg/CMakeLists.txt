add_gdal_driver(TARGET gdal_MSG SOURCES msgcommand.cpp msgcommand.h msgdataset.cpp msgdataset.h
                prologue.cpp prologue.h PublicDecompWT_all.cpp PublicDecompWT_headers.h
                reflectancecalculator.h reflectancecalculator.cpp xritheaderparser.cpp xritheaderparser.h)
target_compile_definitions(gdal_MSG PRIVATE DEFINITIONS -DDO_NOT_USE_DEBUG_BOOL)
target_include_directories(gdal_MSG PRIVATE PublicDecompWT/DISE
                     PublicDecompWT/COMP/WT/Inc
                     PublicDecompWT/COMP/Inc )