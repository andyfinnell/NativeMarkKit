import Foundation
import XCTest
import NativeMarkKit
#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

#if true // TODO: have to turn these off because GitHub actions are stuck on Catalina
final class NativeMarkStringDrawTest: XCTestCase {
    override func setUp() {
        super.setUp()
        
        // Force rendering to happen in light mode
        if #available(OSX 10.14, *) {
            #if canImport(AppKit)
            NSApplication.shared.appearance = NSAppearance(named: .aqua)
            #endif
        }
        
        if #available(iOS 13.0, tvOS 13.0, *) {
            #if canImport(UIKit)
            for window in UIApplication.shared.windows {
                window.overrideUserInterfaceStyle = .light
            }
            #endif
        }
    }
    
    func testHelloWorldAtOrigin() {
        let string = NativeMarkString(nativeMark: "**Hello**, _world_!", styleSheet: .default)
        let bounds = string.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude,
                                                      height: .greatestFiniteMagnitude))
        let testCase = DrawRenderTestCase(name: "Draw_HelloWorldAtOrigin",
                                          size: bounds.integral.size) {
                                            string.draw(at: .zero)
        }
        XCTAssert(testCase.isPassing(for: self))
    }
    
    func testBasicDocNoWrapping() {
        let nativeMark = """
# My Document

This is the _beginning_ of the document. It's
a paragraph, because reasons. It's not yet the
**end** of the document, but maybe only of the
paragraph.

## Subheading 1

The heading above this is smaller for reasons. Those reasons
should not be confused with these other reasons that I don't
know about.

I should probably have at least one section with more than
one paragraph. That might be a better test case that just
a single paragraph section. Words, words, words.

### Headings get smaller with time

And now for something completely different.

#### Out of ideas

I need more paragraphs of text to work with.
This isn't as easy as I thought it would be.
I need more coffee.

"""
        let string = NativeMarkString(nativeMark: nativeMark, styleSheet: .default)
        let bounds = string.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude,
                                                      height: .greatestFiniteMagnitude))
        let testCase = DrawRenderTestCase(name: "Draw_BasicDocNoWrapping",
                                          size: bounds.integral.size) {
                                            string.draw(at: .zero)
        }
        XCTAssert(testCase.isPassing(for: self))
    }
    
    func testBasicDocWrapping() {
        let nativeMark = """
# My Document

This is the _beginning_ of the document. It's
a paragraph, because reasons. It's not yet the
**end** of the document, but maybe only of the
paragraph.

## Subheading 1

The heading above this is smaller for reasons. Those reasons
should not be confused with these other reasons that I don't
know about.

I should probably have at least one section with more than
one paragraph. That might be a better test case that just
a single paragraph section. Words, words, words.

### Headings get smaller with time

And now for something completely different.

#### Out of ideas

I need more paragraphs of text to work with.
This isn't as easy as I thought it would be.
I need more coffee.

"""
        let string = NativeMarkString(nativeMark: nativeMark, styleSheet: .default)
        let bounds = string.boundingRect(with: CGSize(width: 280,
                                                      height: CGFloat.greatestFiniteMagnitude))
        let testCase = DrawRenderTestCase(name: "Draw_BasicDocWrapping",
                                          size: bounds.integral.size) {
                                            string.draw(in: bounds)
        }
        XCTAssert(testCase.isPassing(for: self))
    }
}
#endif
