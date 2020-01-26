#!/bin/bash

curdir=`pwd`

BUILD_DIR=build-swiftshader
DEST_DIR=${curdir}/dist

mkdir -p ${DEST_DIR}/lib

rm -rf ${BUILD_DIR}
mkdir ${BUILD_DIR}
cd ${BUILD_DIR}

# Disable windowing system for a while.
cmake -G Ninja \
  -DCMAKE_INSTALL_PREFIX=${DEST_DIR} \
  -DSWIFTSHADER_BUILD_EGL=0 \
  -DSWIFTSHADER_BUILD_GLESv2=0 \
  -DSWIFTSHADER_BUILD_GLES_CM=0 \
  -DSWIFTSHADER_BUILD_VULKAN=1 \
  -DSWIFTSHADER_BUILD_SAMPLES=0 \
  -DSWIFTSHADER_BUILD_TESTS=0 \
  ../third_party/swiftshader

ninja && cp Linux/libvk_swiftshader.so ${DEST_DIR}/lib && cp Linux/vk_swiftshader_icd.json ${DEST_DIR}/lib

cd ..

