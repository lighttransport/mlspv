rmdir /s /q build-msvc
mkdir build-msvc

cd build-msvc

cmake.exe -G "Visual Studio 15 2017" -A x64 ..
