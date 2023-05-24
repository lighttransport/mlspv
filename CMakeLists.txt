cmake_minimum_required (VERSION 3.16)
project (vulkan_minimal_compute LANGUAGES C CXX)

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

if (NOT ANDROID)
  # Vulkan-loaders
  set(VulkanHeaders_INCLUDE_DIR ${PROJECT_SOURCE_DIR}/third_party/Vulkan-Headers/include CACHE INTERNAL "" FORCE)
  set(VulkanRegistry_DIR ${PROJECT_SOURCE_DIR}/third_party/Vulkan-Headers/registry CACHE INTERNAL "" FORCE)
  set(BUILD_WSI_XCB_SUPPORT OFF CACHE INTERNAL "" FORCE)
  set(BUILD_WSI_XLIB_SUPPORT OFF CACHE INTERNAL "" FORCE)
  set(BUILD_WSI_WAYLAND_SUPPORT OFF CACHE INTERNAL "" FORCE)
  add_subdirectory(${PROJECT_SOURCE_DIR}/third_party/Vulkan-Loader)
  
  # Vulkan headers
  set(Vulkan_INCLUDE_DIR ${PROJECT_SOURCE_DIR}/third_party/Vulkan-Headers/include)
  include_directories(${Vulkan_INCLUDE_DIR})

  # [swiftshader]
  #add_subdirectory(${PROJECT_SOURCE_DIR}/third_party/swiftshader)
endif (NOT ANDROID)


if (ANDROID)
  # Experimental

  set(BUILD_LIBNAME "mlspv")

  include(${PROJECT_SOURCE_DIR}/cmake/android/APK.cmake)

  set(TEST_SRC
    ${ANDROID_NDK}/sources/android/native_app_glue/android_native_app_glue.c
    ${PROJECT_SOURCE_DIR}/android/app/src/main/cpp/main.cc
    ${PROJECT_SOURCE_DIR}/src/vulkan/android/vulkan_wrapper.cc
    )

  # Make sure that the Android entry point isnt getting stripped, find a better solution
  set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -u ANativeActivity_onCreate")

  set(APP_SHARED_LIBRARIES lib${BUILD_LIBNAME}.so)

  add_library(${BUILD_LIBNAME} SHARED ${TEST_SRC})
  add_sanitizers(${BUILD_LIBNAME})

  target_include_directories(${BUILD_LIBNAME} PRIVATE ${ANDROID_NDK}/sources/android/native_app_glue)
  target_link_libraries(${BUILD_LIBNAME} PRIVATE log android)
 
  android_create_apk(${BUILD_LIBNAME} "${CMAKE_BINARY_DIR}/apk" "${APP_SHARED_LIBRARIES}" "")

else (ANDROID)
  add_executable(${TARGET_NAME}
     src/ggml.c
     src/main.cc)
  
  IF (WIN32)
    # get rid of annoying MSVC warnings.
    target_compile_definitions(${TARGET_NAME} PRIVATE _CRT_SECURE_NO_WARNINGS)
  ENDIF (WIN32)
  
  IF (MSVC)
    set_target_properties(${TARGET_NAME} PROPERTIES VS_DEBUGGER_WORKING_DIRECTORY "${CMAKE_SOURCE_DIR}")
  ENDIF (MSVC)
  
  # Use Vulkan-Loader's libvulkan
  target_link_libraries(${TARGET_NAME} vulkan)
endif (ANDROID)
