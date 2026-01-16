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
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 595, height: 842)) // A4 size
        do {
            try pdfRenderer.writePDF(to: URL(fileURLWithPath: outputPath)) { context in
                for path in imagePaths {
                    if let image = UIImage(contentsOfFile: path) {
                        context.beginPage()
                        let imageRect = AVMakeRect(aspectRatio: image.size, insideRect: CGRect(x: 0, y: 0, width: 595, height: 842))
                        image.draw(in: imageRect)
                    }
                }
            }
            resolve(outputPath)
        } catch {
            reject("pdf_error", "Failed to create PDF", error)
        }
    }
}
