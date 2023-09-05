#!/bin/bash

curdir=`pwd`

BUILD_DIR=validation-layers-build
DEST_DIR=${curdir}/dist

rm -rf ${BUILD_DIR}
mkdir ${BUILD_DIR}

cd ${BUILD_DIR}

## glslang

### Need to checkout spirv-tools since Vulkan-ValidationLayers requires it.
curdir=`pwd`
cd ../third_party/glslang
python update_glslang_sources.py
cd ${curdir}

mkdir glslang
cd glslang

cmake -G Ninja -DCMAKE_INSTALL_PREFIX=${DEST_DIR} ../../third_party/glslang

ninja && ninja install

cd ..

## Vulkan-Headers(just copy files)

mkdir vulkan-headers

cd vulkan-headers

cmake -G Ninja -DCMAKE_INSTALL_PREFIX=${DEST_DIR} ../../third_party/Vulkan-Headers

ninja && ninja install

cd ..

## Vulkan-Utility-Libraries

mkdir vulkan-utility-libraries

cd vulkan-utility-libraries

CXX=clang++ CC=clang cmake -G Ninja -DCMAKE_INSTALL_PREFIX=${DEST_DIR} ../../third_party/Vulkan-Utility-Libraries

ninja && ninja install

cd ..


## Vulkan-ValidationLayers

mkdir vulkan-validationlayers

cd vulkan-validationlayers

# Disable windowing system for a while.
CXX=clang++ CC=clang cmake -G Ninja \
  -DCMAKE_INSTALL_PREFIX=${DEST_DIR} \
  -DVULKAN_HEADERS_INSTALL_DIR=${DEST_DIR} \
  -DGLSLANG_INSTALL_DIR=${DEST_DIR} \
  -DBUILD_WSI_XCB_SUPPORT=Off \
  -DBUILD_WSI_XLIB_SUPPORT=Off \
  -DBUILD_WSI_WAYLAND_SUPPORT=Off \
  ../../third_party/Vulkan-ValidationLayers

ninja && ninja install

cd ..

