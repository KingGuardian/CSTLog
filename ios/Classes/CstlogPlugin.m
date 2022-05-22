#import "CstlogPlugin.h"
#if __has_include(<cstlog/cstlog-Swift.h>)
#import <cstlog/cstlog-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "cstlog-Swift.h"
#endif

@implementation CstlogPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftCstlogPlugin registerWithRegistrar:registrar];
}
@end
