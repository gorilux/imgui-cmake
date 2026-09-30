project('imgui', 'cpp',
    version: '1.86',
    license: 'MIT',
)

include_dirs = include_directories('imgui',  'imgui/backends', '.')
sources = [
    'imgui/imgui_demo.cpp', 
    'imgui/imgui_draw.cpp', 
    'imgui/imgui_tables.cpp', 
    'imgui/imgui_widgets.cpp', 
    'imgui/imgui.cpp',
    'imgui/misc/cpp/imgui_stdlib.cpp',
    'imgui/misc/cpp/imgui_stdlib.h',
    # 'imgui-node-editor/crude_json.cpp',
    # 'imgui-node-editor/crude_json.h',
    # 'imgui-node-editor/imgui_bezier_math.h',    
    # 'imgui-node-editor/imgui_canvas.cpp',
    # 'imgui-node-editor/imgui_canvas.cpp',
    # 'imgui-node-editor/imgui_canvas.h',
    # 'imgui-node-editor/imgui_canvas.h',
    # 'imgui-node-editor/imgui_extra_math.h',    
    # 'imgui-node-editor/imgui_node_editor_api.cpp',
    # 'imgui-node-editor/imgui_node_editor_internal.h',    
    # 'imgui-node-editor/imgui_node_editor.cpp',
    # 'imgui-node-editor/imgui_node_editor.h',
    # 'imgui-node-editor/imgui_node_editor.h',
   
    
]

cpp = meson.get_compiler('cpp')
dependencies = []
compiler_args = ['-DIMGUI_DEFINE_MATH_OPERATORS', '-DImDrawIdx=unsigned int']
linker_args = []
system = host_machine.system()

# renderer backends
if system == 'emscripten'
    sources += [ 
        'imgui/backends/imgui_impl_sdl2.cpp' , 
        'imgui/backends/imgui_impl_opengl3.cpp'
    ]
    compiler_args = [
    '-s', 'USE_SDL=2',    
    '-s', 'DISABLE_EXCEPTION_CATCHING=1',    
    '-s', 'USE_SDL_IMAGE=2'    
    ]

    linker_args = [
    '-s', 'USE_SDL=2',
    '-s', 'USE_BOOST_HEADERS=1',
    '-s', 'ENVIRONMENT=web,worker',
    '-s', 'FORCE_FILESYSTEM=1',
    '-s', 'ALLOW_MEMORY_GROWTH=1',    
    '-s', 'NO_EXIT_RUNTIME=0',
    '-s', 'ASSERTIONS=1',
    '-s', 'WASM=1',    
    '--preload-file', meson.current_source_dir() + '/imgui/misc/fonts@/fonts',
    '--use-preload-plugins',
    '-pthread'
    ]
    ## '--no-heap-copy',
    # '-s', 'INITIAL_MEMORY=128MB',
    # '-s', 'TOTAL_STACK=64MB',
elif system == 'android'
    sources += [
        'imgui/backends/imgui_impl_sdl2.cpp',
        'imgui/backends/imgui_impl_opengl3.cpp',
    ]
    compiler_args += ['-DIMGUI_IMPL_OPENGL_ES3']
    sdl2_dep = dependency('sdl2')
    dependencies += [
        sdl2_dep,
        cpp.find_library('EGL'),
        cpp.find_library('GLESv3'),
        cpp.find_library('android'),
        cpp.find_library('log'),
    ]

elif system == 'windows'
    # Windows via the mingw-w64 cross toolchain. Same backend pair as Linux:
    # SDL2 for the platform layer, desktop GL for the renderer.
    #
    # This arm is REQUIRED — the generic `else` fallback below cannot serve
    # Windows. It probes DX9/10/11/12, Metal, Vulkan, GLFW and Allegro, and
    # it references 'imgui/backends/imgui_impl_sdl.cpp', a filename upstream
    # retired when the backend was split into imgui_impl_sdl2.cpp /
    # imgui_impl_sdl3.cpp. Configuring through it fails outright.
    #
    # opengl32.dll exports OpenGL 1.1 only, so every GL 2+ entry point has to
    # be resolved at runtime. imgui's renderer backend carries its own private
    # loader (imgui_impl_opengl3_loader.h) and is self-sufficient; the
    # application-side GL calls live in libs/imgui_ecs, which loads them
    # through glad.
    sources += [
        'imgui/backends/imgui_impl_sdl2.cpp',
        'imgui/backends/imgui_impl_opengl3.cpp',
    ]

    sdl2_dep = dependency('sdl2')
    dependencies += [ sdl2_dep, cpp.find_library('opengl32') ]

elif system == 'linux'
    sources += [
        'imgui/backends/imgui_impl_sdl2.cpp' ,
        'imgui/backends/imgui_impl_opengl3.cpp'
    ]

    sdl2_dep = dependency('sdl2')
    dependencies += [ sdl2_dep, dependency('OpenGL') ]
    # LIBS += $(LINUX_GL_LIBS) -ldl `sdl2-config --libs`

	# CXXFLAGS += `sdl2-config --cflags`
    # LINUX_GL_LIBS = -lGL
else
    dx9_dep = cpp.find_library('d3d9', required: get_option('dx9'))
    if dx9_dep.found()
        sources += 'imgui/backends/imgui_impl_dx9.cpp'
        dependencies += dx9_dep
    endif
    dx10_dep = cpp.find_library('d3d10', required: get_option('dx10'))
    if dx10_dep.found()
        sources += 'imgui/backends/imgui_impl_dx10.cpp'
        dependencies += dx10_dep
    endif
    dx11_dep = cpp.find_library('d3d11', required: get_option('dx11'))
    if dx11_dep.found()
        sources += 'imgui/backends/imgui_impl_dx11.cpp'
        dependencies += dx11_dep
    endif
    dx12_dep = cpp.find_library('d3d12', required: get_option('dx12'))
    if dx12_dep.found()
        sources += 'imgui/backends/imgui_impl_dx12.cpp'
        dependencies += dx12_dep
    endif
    metal_dep = dependency('appleframeworks', modules : 'metal', required: get_option('metal'))
    if metal_dep.found()
        sources += 'imgui/backends/imgui_impl_metal.mm'
        dependencies += metal_dep
    endif
    libdl_dep = cpp.find_library('dl', required: get_option('opengl'))
    if libdl_dep.found()
        sources += 'imgui/backends/imgui_impl_opengl3.cpp'
        dependencies += libdl_dep
    endif
    sdl2_renderer_dep = dependency('sdl2', version: '>=2.0.17', required: get_option('sdl_renderer'))
    if sdl2_renderer_dep.found()
        sources += 'imgui/backends/imgui_impl_sdlrenderer.cpp'
        dependencies += sdl2_renderer_dep
    endif
    vulkan_dep = dependency('vulkan', required: get_option('vulkan'))
    if vulkan_dep.found()
        sources += 'imgui/backends/imgui_impl_vulkan.cpp'
        dependencies += vulkan_dep
    endif
    if cpp.has_header('webgpu/webgpu.h', required: get_option('webgpu'))
        sources += 'imgui/backends/imgui_impl_wgpu.cpp'
    endif

    # platform backends
    glfw_dep = dependency('glfw3', required: get_option('glfw'))
    if glfw_dep.found()
        sources += 'imgui/backends/imgui_impl_glfw.cpp'
        dependencies += glfw_dep
    endif
    sdl2_dep = dependency('sdl2', required: get_option('sdl2'))
    if sdl2_dep.found()
        sources += 'imgui/backends/imgui_impl_sdl.cpp'
        dependencies += sdl2_dep
    endif
    if get_option('osx').enabled() or (get_option('osx').auto() and target_machine.system() == 'darwin')
        sources += 'imgui/backends/imgui_impl_osx.mm'
    endif
    if get_option('win').enabled() or (get_option('win').auto() and target_machine.system() == 'windows')
        sources += 'imgui/backends/imgui_impl_win32.cpp'
    endif

    # frameworks
    allegro5_dep = dependency('allegro-5', required: get_option('allegro5'))
    allegro5_primitives_dep = dependency('allegro_primitives-5', required: get_option('allegro5'))
    if allegro5_dep.found() and allegro5_primitives_dep.found()
        sources += 'imgui/imgui/backends/imgui_impl_allegro5.cpp'
        dependencies += [allegro5_dep, allegro5_primitives_dep]
endif

endif

# binary_to_compressed_c is a developer helper that turns a font/image into a
# C array. It is a BUILD-HOST tool, so cross builds skip it: the produced
# binary could not run here anyway, and on Windows it fails to link outright —
# `dependencies` carries SDL2, whose sdl2.pc pulls in -lSDL2main, and SDL2main
# provides the entry point and then demands an SDL_main symbol that this
# plain-main() tool does not define.
if not meson.is_cross_build()
    executable('binary_to_compressed_c',
        'imgui/misc/fonts/binary_to_compressed_c.cpp',
        dependencies: dependencies,
        include_directories: include_dirs,
        c_args:compiler_args, 
        cpp_args:compiler_args, 
        link_args:linker_args
    )
endif

imgui = static_library('imgui',
    sources,
    dependencies: dependencies,
    include_directories: include_dirs,
    c_args:compiler_args, 
    cpp_args:compiler_args, 
    link_args:linker_args
)

imgui_dep = declare_dependency(
    include_directories: include_dirs, 
    dependencies: dependencies,
    link_with: imgui,     
    compile_args: compiler_args,
    link_args: linker_args
)
