#import "FlutterOkSdkPlugin.h"
#import <flutter_ok_sdk/flutter_ok_sdk-Swift.h>

@implementation FlutterOkSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    [SwiftFlutterOkSdkPlugin registerWithRegistrar:registrar];
}
@end
