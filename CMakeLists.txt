#
# ImGui Library
#
cmake_minimum_required(VERSION 3.6.0)

include(CMakeOptions.cmake)
include(CMakeImplFiles.cmake)


##################################################################################################################
# Setup (change imgui version according to your needs)
##################################################################################################################
project(imgui        
        LANGUAGES CXX
        DESCRIPTION "ImGui library."
)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin/$<CONFIG>)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin/$<CONFIG>)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin/$<CONFIG>)
set(CMAKE_PDB_OUTPUT_DIRECTORY     ${CMAKE_BINARY_DIR}/bin/$<CONFIG>)

set(CMAKE_VERBOSE_MAKEFILE TRUE)
set(IMGUI_STATIC_LIBRARY TRUE CACHE BOOL "Build ImGui as a static library") 

if (WIN32)
  if (IMGUI_STATIC_LIBRARY)
    message(STATUS "[INFO] Building library as --> Static Library")
    set(BUILD_SHARED_LIBS OFF)
    set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS OFF)
  else()
    message(STATUS "[INFO] Building library as --> DLL")
    set(BUILD_SHARED_LIBS ON)
    set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)
  endif()
endif()

set(IMGUI_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/imgui)
set(IMGUI_EXAMPLES_DIR ${IMGUI_SOURCE_DIR}/examples)
set(IMGUI_BACKENDS_DIR ${IMGUI_SOURCE_DIR}/backends)
set(IMGUI_FONTS_DIR ${IMGUI_SOURCE_DIR}/misc/fonts)


##################################################################################################################
# Project Files
##################################################################################################################
set(IMGUI_HEADERS_CXX_FILES 
    ${IMGUI_SOURCE_DIR}/imgui.h
    ${IMGUI_SOURCE_DIR}/imconfig.h
    ${IMGUI_SOURCE_DIR}/imgui_internal.h
    ${IMGUI_SOURCE_DIR}/imstb_rectpack.h
    ${IMGUI_SOURCE_DIR}/imstb_textedit.h
    ${IMGUI_SOURCE_DIR}/imstb_truetype.h
)

set(IMGUI_SOURCES_CXX_FILES 
    ${IMGUI_SOURCE_DIR}/imgui.cpp
    ${IMGUI_SOURCE_DIR}/imgui_draw.cpp
    ${IMGUI_SOURCE_DIR}/imgui_widgets.cpp
    ${IMGUI_SOURCE_DIR}/imgui_tables.cpp
    ${IMGUI_SOURCE_DIR}/imgui_demo.cpp
)

file(GLOB IMGUI_FONTS_FILES ${IMGUI_FONTS_DIR}/*.ttf)

set(IMGUI_HEADERS_CXX_IMPL_FILES)
set(IMGUI_SOURCES_CXX_IMPL_FILES)
if (IMGUI_WITH_IMPL)
  Init_Impl_Files(IMGUI_HEADERS_CXX_IMPL_FILES IMGUI_SOURCES_CXX_IMPL_FILES)
endif()


##################################################################################################################
# IDE Representation
##################################################################################################################
# Groups CMake pre-defined projects:
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

source_group("Header Files" FILES
    ${IMGUI_HEADERS_CXX_FILES}
)
source_group("Header Files\\Impl" FILES
    ${IMGUI_HEADERS_CXX_IMPL_FILES}
)
source_group("Source Files" FILES
    ${IMGUI_SOURCES_CXX_FILES}
)
source_group("Source Files\\Impl" FILES
    ${IMGUI_SOURCES_CXX_IMPL_FILES}
)
source_group("Resource Files" FILES
    ${IMGUI_FONTS_FILES}
)


##################################################################################################################
# Target
##################################################################################################################
add_library(${PROJECT_NAME} STATIC
    ${IMGUI_HEADERS_CXX_FILES}
    ${IMGUI_SOURCES_CXX_FILES}
    ${IMGUI_HEADERS_CXX_IMPL_FILES}
    ${IMGUI_SOURCES_CXX_IMPL_FILES}
    ${IMGUI_FONTS_FILES}
)
target_include_directories(${PROJECT_NAME} PUBLIC 
    ${IMGUI_SOURCE_DIR}
    ${IMGUI_SOURCE_DIR}/examples
    ${IMGUI_SOURCE_DIR}/backends
)
if(IMGUI_IMPL_DX12 AND NOT IMGUI_STATIC_LIBRARY)
    target_link_libraries(${PROJECT_NAME} PUBLIC d3d12)
endif()


if(IMGUI_IMPL_SDL_OPENGL3 AND ${CMAKE_SYSTEM_NAME} MATCHES "Emscripten")
target_compile_options(${PROJECT_NAME} PUBLIC -s USE_SDL=2 )
target_link_options(${PROJECT_NAME} PUBLIC "-s WASM=1")
target_link_options(${PROJECT_NAME} PUBLIC "-s ALLOW_MEMORY_GROWTH=1")
target_link_libraries(${PROJECT_NAME} PUBLIC "-s DISABLE_EXCEPTION_CATCHING=1" "-s NO_EXIT_RUNTIME=0" "-s USE_SDL=2")
target_link_libraries(${PROJECT_NAME} PUBLIC "-s ASSERTIONS=1")
target_link_libraries(${PROJECT_NAME} PUBLIC --no-heap-copy "--preload-file ${IMGUI_SOURCE_DIR}/misc/fonts@/fonts")

endif()

##################################################################################################################
# Target Install
##################################################################################################################
set (DISTRIBUTE_DIR ${CMAKE_BINARY_DIR}/dist/$<CONFIG>)
install(
    TARGETS ${PROJECT_NAME}
    RUNTIME DESTINATION ${DISTRIBUTE_DIR}/bin
    LIBRARY DESTINATION ${DISTRIBUTE_DIR}/lib
    ARCHIVE DESTINATION ${DISTRIBUTE_DIR}/lib
)
install(
    FILES ${IMGUI_HEADERS_CXX_FILES} ${IMGUI_HEADERS_CXX_IMPL_FILES}
    DESTINATION ${DISTRIBUTE_DIR}/include
)
install(
    FILES ${IMGUI_FONTS_FILES}
    DESTINATION ${DISTRIBUTE_DIR}/misc/fonts
)

# Install PDB files for VS builds to enable debugging:
if (MSVC)
  if (NOT IMGUI_STATIC_LIBRARY)
    install(
        FILES $<TARGET_PDB_FILE:${PROJECT_NAME}> 
        DESTINATION ${DISTRIBUTE_DIR}/lib
        CONFIGURATIONS Debug OR RelWithDebInfo
        COMPONENT libraries
        OPTIONAL
    )
  else()
    install(
        FILES 
          $<$<CONFIG:Debug>:${CMAKE_BINARY_DIR}/bin/$<CONFIG>/${PROJECT_NAME}.pdb>
          $<$<CONFIG:RelWithDebInfo>:${CMAKE_BINARY_DIR}/${PROJECT_NAME}.dir/$<CONFIG>/${PROJECT_NAME}.pdb>
        DESTINATION ${DISTRIBUTE_DIR}/lib
        CONFIGURATIONS Debug OR RelWithDebInfo
        COMPONENT libraries
        OPTIONAL
    )
  endif()
endif()

