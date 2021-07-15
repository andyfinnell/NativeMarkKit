import Foundation
import XCTest
@testable import NativeMarkKit
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

final class TextStyleTest: XCTestCase {
    func testCustomFontsWhenAvenirMedium() {
        let subject = TextStyle.custom(name: .custom("Avenir-Medium"),
                                       size: .fixed(19),
                                       traits: .unspecified)
        
        let plainFont = subject.makeFont()
        XCTAssertEqual(plainFont.fontName, "Avenir-Medium")
        
        let italicFont = plainFont.withTraits(.italic)
        XCTAssertEqual(italicFont?.fontName, "Avenir-MediumOblique")

        let boldFont = plainFont.withTraits(.bold)
        XCTAssertEqual(boldFont?.fontName, "Avenir-Heavy")

        let boldItalicFont = plainFont.withTraits([.italic, .bold])
        XCTAssertEqual(boldItalicFont?.fontName, "Avenir-HeavyOblique")
        
        let boldItalicFont2 = plainFont.withTraits(.italic)?.withTraits(.bold)
        XCTAssertEqual(boldItalicFont2?.fontName, "Avenir-HeavyOblique")

        let boldItalicFont3 = plainFont.withTraits(.bold)?.withTraits(.italic)
        XCTAssertEqual(boldItalicFont3?.fontName, "Avenir-HeavyOblique")

    }
    
    func testCustomFontsWhenAvenirRoman() {
        let subject = TextStyle.custom(name: .custom("Avenir-Roman"),
                                       size: .fixed(19),
                                       traits: .unspecified)
        
        let plainFont = subject.makeFont()
        XCTAssertEqual(plainFont.fontName, "Avenir-Roman")
        
        let italicFont = plainFont.withTraits(.italic)
        XCTAssertEqual(italicFont?.fontName, "Avenir-BookOblique")

        let boldFont = plainFont.withTraits(.bold)
        XCTAssertEqual(boldFont?.fontName, "Avenir-Heavy")

        let boldItalicFont = plainFont.withTraits([.italic, .bold])
        XCTAssertEqual(boldItalicFont?.fontName, "Avenir-HeavyOblique")
    }
}
