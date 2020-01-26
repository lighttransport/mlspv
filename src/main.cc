#include <cassert>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <iostream>
#include <string>
#include <vector>

// vulkan loader
#include <vulkan/vulkan.h>

// Used for validating return values of Vulkan API calls.
#define VK_CHECK_RESULT(f)                                               \
  {                                                                      \
    VkResult res = (f);                                                  \
    if (res != VK_SUCCESS) {                                             \
      printf("Fatal : VkResult is %d in %s at line %d\n", res, __FILE__, \
             __LINE__);                                                  \
      assert(res == VK_SUCCESS);                                         \
    }                                                                    \
  }

int main(int argc, char **argv) {
  bool enableValidationLayers = true;

  std::vector<const char *> enabledLayers;

  std::vector<const char *> enabledExtensions;

  /*
  By enabling validation layers, Vulkan will emit warnings if the API
  is used incorrectly. We shall enable the layer
  VK_LAYER_LUNARG_standard_validation, which is basically a collection of
  several useful validation layers.
  */
  std::cout << "enableValidationLayers = " << enableValidationLayers << "\n";
  if (enableValidationLayers) {
    /*
    We get all supported layers with vkEnumerateInstanceLayerProperties.
    */
    uint32_t layerCount;
    vkEnumerateInstanceLayerProperties(&layerCount, NULL);

    std::vector<VkLayerProperties> layerProperties(layerCount);
    vkEnumerateInstanceLayerProperties(&layerCount, layerProperties.data());

    /*
    And then we simply check if VK_LAYER_LUNARG_standard_validation is among the
    supported layers.
    */
    bool foundLayer = false;
    for (VkLayerProperties prop : layerProperties) {
      std::cout << "layer: " << prop.layerName << "\n";
    }

    for (VkLayerProperties prop : layerProperties) {
      if (strcmp("VK_LAYER_LUNARG_standard_validation", prop.layerName) == 0) {
        foundLayer = true;
        break;
      }
    }

    if (!foundLayer) {
      throw std::runtime_error(
          "Layer VK_LAYER_LUNARG_standard_validation not supported\n");
    }
    enabledLayers.push_back(
        "VK_LAYER_LUNARG_standard_validation");  // Alright, we can use this
                                                 // layer.

    /*
    We need to enable an extension named VK_EXT_DEBUG_REPORT_EXTENSION_NAME,
    in order to be able to print the warnings emitted by the validation layer.

    So again, we just check if the extension is among the supported extensions.
    */

    uint32_t extensionCount;

    vkEnumerateInstanceExtensionProperties(NULL, &extensionCount, NULL);
    std::vector<VkExtensionProperties> extensionProperties(extensionCount);
    vkEnumerateInstanceExtensionProperties(NULL, &extensionCount,
                                           extensionProperties.data());

    bool foundExtension = false;
    for (VkExtensionProperties prop : extensionProperties) {
      if (strcmp(VK_EXT_DEBUG_REPORT_EXTENSION_NAME, prop.extensionName) == 0) {
        foundExtension = true;
        break;
      }
    }

    if (!foundExtension) {
      throw std::runtime_error(
          "Extension VK_EXT_DEBUG_REPORT_EXTENSION_NAME not supported\n");
    }
    enabledExtensions.push_back(VK_EXT_DEBUG_REPORT_EXTENSION_NAME);
  }

  for (const auto *layer : enabledLayers) {
    std::cout << layer << "\n";
  }

  return EXIT_SUCCESS;

}
