## Please edit android sdk/ndk/cmake path
ANDROID_SDK_ROOT=$HOME/Android/Sdk/

# NDK r21 or later required
ANDROID_NDK_ROOT=$HOME/Android/Sdk/ndk/21.0.6113669

# cmake 3.7 or later, or use cmake installed from Android sdkman
CMAKE_BIN=$ANDROID_SDK_ROOT/cmake/3.10.2.4988404/bin/cmake

# Assume path is set for `ninja`, `aapt`, `jarsigner` and `zipalign`

BUILD_DIR=build-android-apk


rm -rf ${BUILD_DIR}
mkdir ${BUILD_DIR}

# ANDROID_SDK_HOME: Used in `cmake/android/APK.cmake`
cd ${BUILD_DIR} && ${CMAKE_BIN} -G Ninja \
  -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK_ROOT/build/cmake/android.toolchain.cmake \
  -DANDROID_ABI=arm64-v8a \
  -DANDROID_NATIVE_API_LEVEL=28 \
  -DANDROID_STL=c++_shared \
  -DANDROID_SDK_HOME=${ANDROID_SDK_ROOT} \
  -DANDROID_NDK_HOME=${ANDROID_NDK_ROOT} \
  -DCMAKE_BUILD_TYPE=Debug \
  ..

cd ..

