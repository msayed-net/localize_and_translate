#import "LocalizeAndTranslatePlugin.h"
#if __has_include(<localize_and_translate/localize_and_translate-Swift.h>)
#import <localize_and_translate/localize_and_translate-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "localize_and_translate-Swift.h"
#endif

@implementation LocalizeAndTranslatePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftLocalizeAndTranslatePlugin registerWithRegistrar:registrar];
}
@end
