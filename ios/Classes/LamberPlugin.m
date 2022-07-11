#import "LamberPlugin.h"
#if __has_include(<lamber/lamber-Swift.h>)
#import <lamber/lamber-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "lamber-Swift.h"
#endif

@implementation LamberPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftLamberPlugin registerWithRegistrar:registrar];
}
@end
