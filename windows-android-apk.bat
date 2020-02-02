rem Please edit android sdk/ndk/cmake path
set ANDROID_SDK_ROOT=%HOME%/AppData/Local/Android/sdk/

rem NDK r21 or later required
set ANDROID_NDK_ROOT=%ANDROID_SDK_ROOT%/ndk/21.0.6113669

rem cmake 3.7 or later, or use cmake installed from Android sdkman
set CMAKE_BIN=%ANDROID_SDK_ROOT%/cmake/3.10.2.4988404/bin/cmake.exe

rem Assume path is set for `ninja`, `aapt`, `jarsigner` and `zipalign`
rem e.g. appt for C:\Users\<user>\AppData\Local\Android\sdk\build-tools\29.0.2

set BUILD_DIR=build-android-apk

rmdir /s /q %BUILD_DIR%
mkdir %BUILD_DIR%

cd %BUILD_DIR%

%CMAKE_BIN% -G Ninja ^
  -DCMAKE_TOOLCHAIN_FILE=%ANDROID_NDK_ROOT%/build/cmake/android.toolchain.cmake ^
  -DANDROID_ABI=arm64-v8a ^
  -DANDROID_NATIVE_API_LEVEL=28 ^
  -DANDROID_STL=c++_shared ^
  -DANDROID_SDK_HOME=%ANDROID_SDK_ROOT% ^
  -DANDROID_NDK_HOME=%ANDROID_NDK_ROOT% ^
  -DANDROID_APK_SIGNER_DEBUG_KEYSTORE=%HOME%/.android/debug.keystore ^
  -DCMAKE_BUILD_TYPE=Debug ^
  ..

cd ..
