#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>

// Define the plugin using the CAP_PLUGIN Macro, and
// each method the plugin supports using the CAP_PLUGIN_METHOD macro.
CAP_PLUGIN(CapCoreMLPlugin, "CapCoreML",
           CAP_PLUGIN_METHOD(echo, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(download, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(load, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(compile, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(prediction, CAPPluginReturnPromise);
)
