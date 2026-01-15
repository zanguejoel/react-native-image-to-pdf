#import <ImageToPdfSpec/ImageToPdfSpec.h>


@interface ImageToPdf : NSObject <NativeImageToPdfSpec>

// Converts an array of image paths to a PDF at the given output path
- (void)convertImagesToPdf:(NSArray<NSString *> *)imagePaths
					outputPath:(NSString *)outputPath
						resolve:(RCTPromiseResolveBlock)resolve
						 reject:(RCTPromiseRejectBlock)reject;

@end
