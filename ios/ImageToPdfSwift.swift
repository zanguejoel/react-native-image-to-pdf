import Foundation
import UIKit
import React

@objc(ImageToPdfSwift)
public class ImageToPdfSwift: NSObject {
    private func aspectFitRect(for size: CGSize, in boundingRect: CGRect) -> CGRect {
        guard size.width > 0 && size.height > 0 && boundingRect.width > 0 && boundingRect.height > 0 else {
            return boundingRect
        }
        let widthRatio = boundingRect.width / size.width
        let heightRatio = boundingRect.height / size.height
        let scale = min(widthRatio, heightRatio)
        let fittedSize = CGSize(width: size.width * scale, height: size.height * scale)
        let origin = CGPoint(x: boundingRect.origin.x + (boundingRect.width - fittedSize.width) / 2,
                             y: boundingRect.origin.y + (boundingRect.height - fittedSize.height) / 2)
        return CGRect(origin: origin, size: fittedSize)
    }

    @objc
    public func convertImagesToPdf(_ imagePaths: [String], outputPath: String, resolver: RCTPromiseResolveBlock, rejecter: RCTPromiseRejectBlock) {
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 595, height: 842)) // A4 size
        do {
            try pdfRenderer.writePDF(to: URL(fileURLWithPath: outputPath)) { context in
                for path in imagePaths {
                    if let image = UIImage(contentsOfFile: path) {
                        context.beginPage()
                        let pageRect = CGRect(x: 0, y: 0, width: 595, height: 842)
                        let imageRect = aspectFitRect(for: image.size, in: pageRect)
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

