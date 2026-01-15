#import "ImageToPdf.h"

    NSNumber *result = @(a * b);

    return result;

#import "ImageToPdfSwift-Swift.h"

@implementation ImageToPdf
- (NSNumber *)multiply:(double)a b:(double)b {
    NSNumber *result = @(a * b);
    return result;
}

// Bridge to Swift PDF conversion
- (void)convertImagesToPdf:(NSArray<NSString *> *)imagePaths
               outputPath:(NSString *)outputPath
                  resolve:(RCTPromiseResolveBlock)resolve
                   reject:(RCTPromiseRejectBlock)reject {
    ImageToPdfSwift *swiftHelper = [ImageToPdfSwift new];
    [swiftHelper convertImagesToPdf:imagePaths outputPath:outputPath resolver:resolve rejecter:reject];
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
