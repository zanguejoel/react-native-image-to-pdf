import Foundation
import UIKit
import React
import AVFoundation

@objc(ImageToPdf)
class ImageToPdf: NSObject, RCTBridgeModule {
    static func moduleName() -> String! {
        return "ImageToPdf"
    }

    // Expose multiply to Objective-C and React Native
    @objc(multiply:b:)
    func multiply(_ a: Double, b: Double) -> NSNumber {
        return NSNumber(value: a * b)
    }

    @objc
    func createPdfFromImages(
        _ imagePaths: [String],
        outputPath: String,
        resolve: @escaping RCTPromiseResolveBlock,
        reject: @escaping RCTPromiseRejectBlock
    ) {
        DispatchQueue.global(qos: .userInitiated).async {
            let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 595, height: 842)) // A4 size
            
            do {
                // Create directory if it doesn't exist
                let outputUrl = URL(fileURLWithPath: outputPath)
                let directory = outputUrl.deletingLastPathComponent()
                try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
                
                var hasImages = false
                
                try pdfRenderer.writePDF(to: outputUrl) { context in
                    for path in imagePaths {
                        var imageUrl = URL(fileURLWithPath: path)
                        
                        // Handle file:// URLs
                        if path.hasPrefix("file://") {
                            imageUrl = URL(string: path) ?? URL(fileURLWithPath: path)
                        }
                        
                        print("[ImageToPdf] Attempting to load image from: \(path)")
                        
                        // Try to load the image
                        var image: UIImage?
                        
                        // First try with file path
                        image = UIImage(contentsOfFile: imageUrl.path)
                        
                        // If that fails, try with the original path
                        if image == nil {
                            image = UIImage(contentsOfFile: path)
                        }
                        
                        if let image = image {
                            print("[ImageToPdf] Successfully loaded image: \(path), size: \(image.size)")
                            context.beginPage()
                            
                            // Calculate the rectangle maintaining aspect ratio
                            let imageRect = AVMakeRect(
                                aspectRatio: image.size,
                                insideRect: CGRect(x: 0, y: 0, width: 595, height: 842)
                            )
                            
                            image.draw(in: imageRect)
                            hasImages = true
                        } else {
                            print("[ImageToPdf] ERROR: Failed to load image from: \(path)")
                        }
                    }
                }
                
                if hasImages {
                    print("[ImageToPdf] PDF created successfully at: \(outputPath)")
                    DispatchQueue.main.async {
                        resolve(outputPath)
                    }
                } else {
                    DispatchQueue.main.async {
                        reject("no_images", "No images could be loaded from the provided paths", nil)
                    }
                }
            } catch {
                print("[ImageToPdf] ERROR: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    reject("pdf_error", "Failed to create PDF: \(error.localizedDescription)", error)
                }
            }
        }
    }
}
