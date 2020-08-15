import Foundation
import XCTest
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif
import NativeMarkKit

enum RenderTestCaseError: Error {
    case invalidImageData
    case allocationFailure
    case createContextFailure
}

class BaseRenderTestCase {
    enum Validation {
        case pass, fail
    }
    
    let name: String

    init(name: String) {
        self.name = name
    }
    
    func render() -> NativeImage {
        // override point
        fatalError("Override render()")
    }
    
    func isPassing(for activity: XCTActivity, record isRecording: Bool = false) -> Bool {
        if isRecording {
            record()
            return false
        } else {
            return validate(for: activity) == .pass
        }
    }
}

private extension BaseRenderTestCase {
    func record() {
        do {
            try render().pngData()?.write(to: testCaseDataUrl())
        } catch let error {
            XCTFail("Failed to record data for test case \(name) because of \(error)")
        }
    }
    
    func validate(for activity: XCTActivity) -> Validation {
        do {
            let expected = try loadRecordedImage()
            let got = render()
            return try diff(expected, against: got, for: activity)
        } catch let error {
            XCTFail("Failed to validate for test case \(name) because of \(error)")
            return .fail
        }
    }

    func fixturesUrl() throws -> URL {
        let fixturesUrl = URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent("Fixtures")
        try FileManager.default.createDirectory(at: fixturesUrl, withIntermediateDirectories: true, attributes: nil)
        return fixturesUrl
    }
    
    func testCaseDataUrl() throws  -> URL {
        try fixturesUrl().appendingPathComponent("\(name).\(platformName)").appendingPathExtension("png")
    }
    
    var platformName: String {
        #if os(macOS)
        return "macOS"
        #elseif os(iOS)
        return "iOS"
        #elseif os(tvOS)
        return "tvOS"
        #else
        #error("Unsupported platform")
        #endif
    }
    
    func loadRecordedImage() throws -> NativeImage {
        let data = try Data(contentsOf: testCaseDataUrl())
        guard let image = NativeImage(data: data) else {
            throw RenderTestCaseError.invalidImageData
        }
        return image
    }
    
    func diff(_ original: NativeImage, against new: NativeImage, for activity: XCTActivity) throws -> Validation {
        let totalWidth = Int(max(original.size.width, new.size.width))
        let totalHeight = Int(max(original.size.height, new.size.height))
        let rowBytes = (totalWidth * 4).roundedUp(toMultipleOf: 16)
        guard let mutableData = NSMutableData(length: rowBytes * totalHeight) else {
            throw RenderTestCaseError.allocationFailure
        }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(data: mutableData.mutableBytes,
                                      width: totalWidth,
                                      height: totalHeight,
                                      bitsPerComponent: 8,
                                      bytesPerRow: rowBytes,
                                      space: colorSpace,
                                      bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue) else {
            throw RenderTestCaseError.createContextFailure
        }
        
        context.push()
        
        context.translateBy(x: 0, y: CGFloat(totalHeight))
        context.scaleBy(x: 1, y: -1)

        original.draw(at: .zero)
                
        new.drawDifference(at: .zero)
        
        context.pop()
        
        if isSimilarEnough(mutableData, rowBytes: rowBytes, totalWidth: totalWidth, totalHeight: totalHeight) {
            return .pass
        }
        
        // We failed so create and attach images to the XCTestCase
        let expectedImage = XCTAttachment(image: original)
        expectedImage.name = "Expected"
        activity.add(expectedImage)
        
        let gotImage = XCTAttachment(image: new)
        gotImage.name = "Got"
        activity.add(gotImage)
        
        if let diffCGImage = context.makeImage() {
            let diffImage = XCTAttachment(image: NativeImage(cgImage: diffCGImage))
            diffImage.name = "Difference"
            activity.add(diffImage)
        }
        
        return .fail
    }
    
    func isSimilarEnough(_ data: NSMutableData, rowBytes: Int, totalWidth: Int, totalHeight: Int) -> Bool {
        for row in 0..<totalHeight {
            let rowByteOffset = row * rowBytes
            let isSimilar = isRowSimilarEnough(data, byteOffset: rowByteOffset, totalWidth: totalWidth)
            if !isSimilar {
                return false
            }
        }
        
        return true
    }
    
    func isRowSimilarEnough(_ data: NSMutableData, byteOffset: Int, totalWidth: Int) -> Bool {
        let differenceThreshold = 17 // between 0 and 255
        let rowLength = totalWidth * 4
        for offset in 0..<rowLength {
            if (offset % 4) == 0 {
                continue // skip alpha channel (which is first)
            }
            let component = data.bytes.load(fromByteOffset: byteOffset + offset, as: UInt8.self)
            if component > differenceThreshold {
                return false
            }
        }
        return true
    }
}

extension FixedWidthInteger {
    func roundedUp(toMultipleOf powerOfTwo: Self) -> Self {
        precondition(powerOfTwo > 0 && powerOfTwo & (powerOfTwo &- 1) == 0)
        return (self + (powerOfTwo &- 1)) & (0 &- powerOfTwo)
    }
}
