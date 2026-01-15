import Foundation
import UIKit

@objc(ImageToPdfSwift)
public class ImageToPdfSwift: NSObject {
    @objc
    public func convertImagesToPdf(_ imagePaths: [String], outputPath: String, resolver: @escaping RCTPromiseResolveBlock, rejecter: @escaping RCTPromiseRejectBlock) {
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
            resolver(outputPath)
        } catch {
            rejecter("pdf_error", "Failed to create PDF", error)
        }
    }
}
