#import "ImageToPdf.h"

@implementation ImageToPdf
- (NSNumber *)multiply:(double)a b:(double)b {
    NSNumber *result = @(a * b);

    return result;
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
