// ImageToPdf.mm

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTConvert.h>
#import <React/RCTLog.h>
// If using TurboModule spec, include its header; otherwise you can remove the next import if not present in your project
// #import <ReactCommon/RCTTurboModule.h>

// Import the generated Swift bridging header so we can call into Swift implementation
#import "ImageToPdf-Swift.h"

// Declare the Objective-C interface for the module
@interface ImageToPdfObjCBridge : NSObject <RCTBridgeModule>
@end

@implementation ImageToPdfObjCBridge

// Export with the module name expected by JavaScript
RCT_EXPORT_MODULE(ImageToPdf);

// Promise-based method callable from JS, forwarding to Swift helper
RCT_REMAP_METHOD(createPdfFromImages,
                 createPdfFromImages:(NSArray<NSString *> *)imagePaths
                 outputPath:(NSString *)outputPath
                 resolver:(RCTPromiseResolveBlock)resolve
                 rejecter:(RCTPromiseRejectBlock)reject)
{
  ImageToPdfSwift *swiftHelper = [ImageToPdfSwift new];

  SEL selector = @selector(createPdfFromImagesWithImagePaths:outputPath:resolver:rejecter:);
  if ([swiftHelper respondsToSelector:selector]) {
    NSMethodSignature *signature = [swiftHelper methodSignatureForSelector:selector];
    if (!signature) {
      NSString *message = @"Failed to get method signature for createPdfFromImagesWithImagePaths:outputPath:resolver:rejecter:";
      RCTLogError(@"%@", message);
      reject(@"no_signature", message, nil);
      return;
    }

    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setSelector:selector];
    [invocation setTarget:swiftHelper];

    // NSInvocation argument indices: 0 = self, 1 = _cmd, then real args start at 2
    NSArray<NSString *> *arg0 = imagePaths;
    NSString *arg1 = outputPath;
    RCTPromiseResolveBlock arg2 = resolve;
    RCTPromiseRejectBlock arg3 = reject;

    [invocation setArgument:&arg0 atIndex:2];
    [invocation setArgument:&arg1 atIndex:3];
    [invocation setArgument:&arg2 atIndex:4];
    [invocation setArgument:&arg3 atIndex:5];

    [invocation invoke];
    return;
  }

  NSString *message = @"ImageToPdfSwift does not expose a compatible selector. Ensure your Swift class declares an @objc method like:\n\n@objc(createPdfFromImagesWithImagePaths:outputPath:resolver:rejecter:)\nfunc createPdfFromImages(imagePaths: [String], outputPath: String, resolver: RCTPromiseResolveBlock, rejecter: RCTPromiseRejectBlock)";
  RCTLogError(@"%@", message);
  reject(@"no_selector", message, nil);
}

+ (BOOL)requiresMainQueueSetup
{
  return NO;
}

@end

// If you are using TurboModules, implement getTurboModule in a separate category or class that matches your RN setup.
// Commented out to avoid duplicate symbol/link errors when TurboModule is not configured.
/*
#import <ReactCommon/RCTTurboModule.h>
#import <react/renderer/components/YourSpec/NativeImageToPdfSpecJSI.h>

@implementation ImageToPdfObjCBridge (TurboModule)
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:(const facebook::react::ObjCTurboModule::InitParams &)params
{
  return std::make_shared<facebook::react::NativeImageToPdfSpecJSI>(params);
}
@end
*/

