cmake_minimum_required (VERSION 3.8)
project (vulkan_minimal_compute)

set(TARGET_NAME mlspv)

#find_package(Vulkan)

option(MLSPV_USE_CCACHE "Compile with ccache(if available. Linux only)" OFF)

if(NOT IS_DIRECTORY "${PROJECT_SOURCE_DIR}/third_party/clspv/include")
  message(
    FATAL_ERROR
      "The glfw submodule directory is missing! "
      "You probably did not clone submodules. It is possible to recover "
      "by running \"git submodule update --init --recursive\" on top-level directory"
    )
endif()

# cmake modules
list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)
find_package(Sanitizers) # Address sanitizer (-DSANITIZE_ADDRESS=ON)

# [ccache]
if(MLSPV_USE_CCACHE)
  if(MSVC)
    # No ccache support
  else()
    find_program(CCACHE_EXE ccache)
    if(CCACHE_EXE)

      message(STATUS "Use ccache : " ${CCACHE_EXE})
      # CMAKE_C_COMPILER_LAUNCHER = available from cmake 3.4+)
      if(CMAKE_C_COMPILER_LAUNCHER)
        set(CMAKE_C_COMPILER_LAUNCHER "${CMAKE_C_COMPILER_LAUNCHER}"
                                      "${CCACHE_EXE}")
      else()
        set(CMAKE_C_COMPILER_LAUNCHER "${CCACHE_EXE}")
      endif()

      if(CMAKE_CXX_COMPILER_LAUNCHER)
        set(CMAKE_CXX_COMPILER_LAUNCHER "${CMAKE_CXX_COMPILER_LAUNCHER}"
                                        "${CCACHE_EXE}")
      else()
        set(CMAKE_CXX_COMPILER_LAUNCHER "${CCACHE_EXE}")
      endif()

    endif(CCACHE_EXE)
  endif()
endif()

set (CMAKE_CXX_STANDARD 11)


# Vulkan-loaders
set(VulkanHeaders_INCLUDE_DIR ${PROJECT_SOURCE_DIR}/third_party/Vulkan-Headers/include CACHE INTERNAL "" FORCE)
set(VulkanRegistry_DIR ${PROJECT_SOURCE_DIR}/third_party/Vulkan-Headers/registry CACHE INTERNAL "" FORCE)
set(BUILD_WSI_XCB_SUPPORT OFF CACHE INTERNAL "" FORCE)
set(BUILD_WSI_XLIB_SUPPORT OFF CACHE INTERNAL "" FORCE)
set(BUILD_WSI_WAYLAND_SUPPORT oFF CACHE INTERNAL "" FORCE)
add_subdirectory(${PROJECT_SOURCE_DIR}/third_party/Vulkan-Loader)

# Vulkan headers
set(Vulkan_INCLUDE_DIR ${PROJECT_SOURCE_DIR}/third_party/Vulkan-Headers/include)
include_directories(${Vulkan_INCLUDE_DIR})

# [swiftshader]
#add_subdirectory(${PROJECT_SOURCE_DIR}/third_party/swiftshader)

add_executable(${TARGET_NAME} src/main.cc)

IF (WIN32)
  # get rid of annoying MSVC warnings.
  target_compile_definitions(${TARGET_NAME} PRIVATE _CRT_SECURE_NO_WARNINGS)
ENDIF (WIN32)

IF (MSVC)
  set_target_properties(${TARGET_NAME} PROPERTIES VS_DEBUGGER_WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}")
ENDIF (MSVC)

# Use Vulkan-Loader's libvulkan
target_link_libraries(${TARGET_NAME} vulkan )
