import Foundation
@testable import NativeMarkKit

#if canImport(AppKit)
import AppKit

extension NativeImage {
    convenience init(cgImage: CGImage) {
        self.init(cgImage: cgImage, size: CGSize(width: cgImage.width, height: cgImage.height))
    }
    
    func pngData() -> Data? {
        tiffRepresentation
            .flatMap { NSBitmapImageRep(data: $0)?.representation(using: .png, properties: [:]) }
    }
    
    func draw(at location: CGPoint) {
        draw(in: CGRect(origin: location, size: size),
             from: .zero,
             operation: .copy,
             fraction: 1.0,
             respectFlipped: true,
             hints: nil)
    }
    
    func drawDifference(at location: CGPoint) {
        draw(in: CGRect(origin: location, size: size),
             from: .zero,
             operation: .difference,
             fraction: 1.0,
             respectFlipped: true,
             hints: nil)
    }
}


#elseif canImport(UIKit)
import UIKit

extension NativeImage {
    func drawDifference(at location: CGPoint) {
        draw(at: location, blendMode: .difference, alpha: 1)
    }
}

#else
#error("Unsupported platform")
#endif
