# MLSpv, Machine Learning with SPIR-V

## Status

Experimental.
Inference only at the moment. 

## Design direction

MLSpv is primarily targeting mobile and edge devices to run ML models.
MLSpv is designed to have capability to run following tasks
  * Differential rendering
  * 3D face reconstruction and rendering
  * Image segmentation, image matting
  * ASR(Automatic Speech Recogniton)
  * TTS(Text To Speech)
  * Transformer based NLP(Natural Language Processing)

MLSpv Use existing eco-system as much as possible.

* Use clspv(OpenCL to SPIR-V) as a HIR(higher level language).
* Use SPIR-V as an IR(intermediate language).
* Use Vulkan as a runtime
  * Use SwiftShader as a CPU fallback
  * Optional: Use SPIRV-Cross to run SPIR-V code on CPU(through C/C++ codegen)

## Supported platforms

* [x] Linux 64bit
  * [x] x86-64
  * [ ] AARCH64
* [x] Windows 10 64bit
* [ ] macOS
* [ ] Android(Inference only)

## Supported GPUs

* [x] AMD GPUs(Vulkan 1.2 or later)
  * [x] RADV(Mesa) driver
  * [ ] amdgpu-pro driver
* [x] NVIDIA GPUs(Vulkan 1.2 or later)
* [ ] Android 10 or later

## Requirements

* C++11 compiler
* CMake
* Ninja(Linux and macOS)
* Python3(to build some submodules)

## Build

### Setup on Unix like system

This step is only required when you checkout the repo or update submodules.
If you have your own build of clspv, SPIRV-Cross, etc. You can skip this step.

#### Build clspv

```
# Checkout llvm and other dependencies required to build clspv
$ ./scripts/setup-clspv.sh

$ ./scripts/build-clspv.sh
```

#### Build ValidationLayers

```
$ ./scripts/build-validation-layers.sh
```

### Setup on Windows

Visual Studio 2017 or later is required to build MLSpv and submodules.

T.B.W.

## TODO

* [ ] iOS support.

## License

MIT license

### Thrid paty licenses

* clspv : Apache 2.0 license. https://github.com/google/clspv
* glslang : See glslang repo for details. https://github.com/KhronosGroup/glslang
  * Required to build ValidationLayers
* swiftshader : Apache 2.0 license. https://swiftshader.googlesource.com/SwiftShader
* Vulkan-Headers : Apache 2.0 license. https://github.com/KhronosGroup/Vulkan-Headers
* Vulkan-Loader : Apache 2.0 license. https://github.com/KhronosGroup/Vulkan-Loader
* Vulkan-ValidationLayers : Apache 2.0 license. https://github.com/KhronosGroup/Vulkan-ValidationLayers
* SPIRV-Cross : Apache 2.0 license. https://github.com/KhronosGroup/SPIRV-Cross/
* rttr(C++ reflection library) : MIT license. https://github.com/rttrorg/rttr

