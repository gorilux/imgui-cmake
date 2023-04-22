project('imgui', 'cpp',
    version: '1.86',
    license: 'MIT',
)

# include_dirs = include_directories('imgui', 'imgui/backends', 'imgui-node-editor', 'imgui-filebrowser')
include_dirs = include_directories('imgui', 
    'imgui/backends',  'imgui-filebrowser')
sources = [
    'imgui/imgui_demo.cpp', 
    'imgui/imgui_draw.cpp', 
    'imgui/imgui_tables.cpp', 
    'imgui/imgui_widgets.cpp', 
    'imgui/imgui.cpp',
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
    'imgui-filebrowser/imfilebrowser.h'
]

cpp = meson.get_compiler('cpp')
dependencies = []
compiler_args = []
linker_args = []
system = host_machine.system()

# renderer backends
if system == 'emscripten'
    sources += [ 
        'imgui/backends/imgui_impl_sdl.cpp' , 
        'imgui/backends/imgui_impl_opengl3.cpp'
    ]
    compiler_args = [
    '-s', 'USE_SDL=2',    
    '-s', 'DISABLE_EXCEPTION_CATCHING=1',    
    '-s', 'USE_SDL_IMAGE=2',     
      
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
    '--no-heap-copy',
    '--preload-file', meson.current_source_dir() + '/imgui/misc/fonts@/fonts',
    '--use-preload-plugins'
    ]
elif system == 'linux'
    sources += [ 
        'imgui/backends/imgui_impl_sdl.cpp' , 
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

imgui = library('imgui',
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
