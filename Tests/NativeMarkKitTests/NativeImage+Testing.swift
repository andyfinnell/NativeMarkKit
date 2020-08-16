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
    
    static func testImage(size: CGSize, draw: () -> Void) -> NativeImage {
        let scale: CGFloat = 2.0 // regardless of actual device, use 2x
        let totalWidth = Int(size.width * scale)
        let totalHeight = Int(size.height * scale)
        let rowBytes = (totalWidth * 4).roundedUp(toMultipleOf: 16)
        guard let mutableData = NSMutableData(length: rowBytes * totalHeight) else {
            return NativeImage(size: size)
        }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(data: mutableData.mutableBytes,
                                      width: totalWidth,
                                      height: totalHeight,
                                      bitsPerComponent: 8,
                                      bytesPerRow: rowBytes,
                                      space: colorSpace,
                                      bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue) else {
            return NativeImage(size: size)
        }
        
        context.push()
        
        context.translateBy(x: 0, y: CGFloat(totalHeight))
        context.scaleBy(x: scale, y: -scale)
        
        draw()
        
        context.pop()

        guard let cgImage = context.makeImage() else {
            return NativeImage(size: size)
        }
        
        return NativeImage(cgImage: cgImage, size: size)
    }
}


#elseif canImport(UIKit)
import UIKit

extension NativeImage {
    static func testImage(size: CGSize, draw: () -> Void) -> NativeImage {
        UIGraphicsBeginImageContext(size.validImageSize)
        draw()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }

    func drawDifference(at location: CGPoint) {
        draw(at: location, blendMode: .difference, alpha: 1)
    }
}

#else
#error("Unsupported platform")
#endif
