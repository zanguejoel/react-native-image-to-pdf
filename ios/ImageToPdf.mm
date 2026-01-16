#import "ImageToPdf.h"


#import "ImageToPdf-Swift.h"
#import <React/RCTBridgeModule.h>

@implementation ImageToPdf
- (NSNumber *)multiply:(double)a b:(double)b {
    NSNumber *result = @(a * b);
    return result;
}




// Bridge to Swift PDF conversion (updated selector)
- (void)createPdfFromImages:(NSArray<NSString *> *)imagePaths
                outputPath:(NSString *)outputPath
                   resolve:(RCTPromiseResolveBlock)resolve
                    reject:(RCTPromiseRejectBlock)reject {
    ImageToPdf *swiftHelper = [ImageToPdf new];
    [swiftHelper createPdfFromImages:imagePaths outputPath:outputPath resolve:resolve reject:reject];
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeImageToPdfSpecJSI>(params);
}

+ (NSString *)moduleName
{
  return @"ImageToPdf";
}

@end





