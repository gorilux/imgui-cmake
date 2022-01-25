#
# ImGui Implementation Files
#
cmake_minimum_required(VERSION 3.6.0)


function(Init_Impl_Files IMGUI_HEADERS_CXX_IMPL_FILES IMGUI_SOURCES_CXX_IMPL_FILES)
  if (IMGUI_IMPL_DX9)
    message(STATUS "[INFO] Including Direct3D9 implementation files.")
    set(IMGUI_HEADERS_CXX_IMPL_FILES
      ${IMGUI_BACKENDS_DIR}/imgui_impl_dx9.h
      ${IMGUI_BACKENDS_DIR}/imgui_impl_win32.h
      PARENT_SCOPE
    )
    set(IMGUI_SOURCES_CXX_IMPL_FILES
      ${IMGUI_BACKENDS_DIR}/imgui_impl_dx9.cpp
      ${IMGUI_BACKENDS_DIR}/imgui_impl_win32.cpp
      PARENT_SCOPE
    )
  elseif(IMGUI_IMPL_DX10)
    message(STATUS "[INFO] Including Direct3D10 implementation files.")
    set(IMGUI_HEADERS_CXX_IMPL_FILES
      ${IMGUI_BACKENDS_DIR}/imgui_impl_dx10.h
      ${IMGUI_BACKENDS_DIR}/imgui_impl_win32.h
      PARENT_SCOPE
    )
    set(IMGUI_SOURCES_CXX_IMPL_FILES
      ${IMGUI_BACKENDS_DIR}/imgui_impl_dx10.cpp
      ${IMGUI_BACKENDS_DIR}/imgui_impl_win32.cpp
      PARENT_SCOPE
    )
  elseif(IMGUI_IMPL_DX11)
    message(STATUS "[INFO] Including Direct3D11 implementation files.")
    set(IMGUI_HEADERS_CXX_IMPL_FILES
      ${IMGUI_BACKENDS_DIR}/imgui_impl_dx11.h
      ${IMGUI_BACKENDS_DIR}/imgui_impl_win32.h
      PARENT_SCOPE
    )
    set(IMGUI_SOURCES_CXX_IMPL_FILES
      ${IMGUI_BACKENDS_DIR}/imgui_impl_dx11.cpp
      ${IMGUI_BACKENDS_DIR}/imgui_impl_win32.cpp
      PARENT_SCOPE
    )
  elseif(IMGUI_IMPL_DX12)
    message(STATUS "[INFO] Including Direct3D12 implementation files.")
    set(IMGUI_HEADERS_CXX_IMPL_FILES
      ${IMGUI_BACKENDS_DIR}/imgui_impl_dx12.h
      ${IMGUI_BACKENDS_DIR}/imgui_impl_win32.h
      PARENT_SCOPE
    )
    set(IMGUI_SOURCES_CXX_IMPL_FILES
      ${IMGUI_BACKENDS_DIR}/imgui_impl_dx12.cpp
      ${IMGUI_BACKENDS_DIR}/imgui_impl_win32.cpp
      PARENT_SCOPE
    )
  elseif(IMGUI_IMPL_SDL_OPENGL3)
  message(STATUS "[INFO] Including SDL Opengl3 implementation files.")
    set(IMGUI_HEADERS_CXX_IMPL_FILES
    ${IMGUI_BACKENDS_DIR}/imgui_impl_sdl.h
      ${IMGUI_BACKENDS_DIR}/imgui_impl_opengl3.h
      PARENT_SCOPE
    )
    set(IMGUI_SOURCES_CXX_IMPL_FILES
      ${IMGUI_BACKENDS_DIR}/imgui_impl_sdl.cpp
      ${IMGUI_BACKENDS_DIR}/imgui_impl_opengl3.cpp
      PARENT_SCOPE
    )    
  else()
    message(WARNING "[WARNING] 'IMGUI_WITH_IMPL' option is ON but no additional files were added. See file 'CMakeOptions.cmake'.")
  endif()
endfunction()
