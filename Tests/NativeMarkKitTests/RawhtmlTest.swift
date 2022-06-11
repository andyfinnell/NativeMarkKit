import Foundation
import XCTest
@testable import NativeMarkKit

final class RawhtmlTest: XCTestCase {
    func testCase614() throws {
        // HTML: <p>&lt;33&gt; &lt;__&gt;</p>\n
        /* Markdown
         <33> <__>
         
         */
        XCTAssertEqual(try compile("<33> <__>\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "<33> <__>", range: (0,0)-(0,8)))
                        ],
                        range: (0, 0)-(0, 9)))
                       ]))
    }
        
    func testCase618() throws {
        // HTML: <p>&lt;a href='bar'title=title&gt;</p>\n
        /* Markdown
         <a href='bar'title=title>
         
         */
        XCTAssertEqual(try compile("<a href='bar'title=title>\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "<a href='bar'title=title>", range: (0,0)-(0,24)))
                        ],
                        range: (0, 0)-(0, 25)))
                       ]))
    }
        
    func testCase621() throws {
        // HTML: <p>foo <!-- this is a\ncomment - with hyphen --></p>\n
        /* Markdown
         foo <!-- this is a
         comment - with hyphen -->
         
         */
        XCTAssertEqual(try compile("foo <!-- this is a\ncomment - with hyphen -->\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "foo <!– this is a", range: (0, 0)-(0, 17))),
                            .softbreak(InlineSoftbreak(range: (0, 18)-(0, 18))),
                            .text(InlineString(text: "comment - with hyphen –>", range: (1, 0)-(1, 24)))
                        ],
                        range: (0, 0)-(1, 25)))
                       ]))
    }
    
    func testCase622() throws {
        // HTML: <p>foo &lt;!-- not a comment -- two hyphens --&gt;</p>\n
        /* Markdown
         foo <!-- not a comment -- two hyphens -->
         
         */
        XCTAssertEqual(try compile("foo <!-- not a comment -- two hyphens -->\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "foo <!– not a comment – two hyphens –>", range: (0, 0)-(0, 40)))
                        ],
                        range: (0, 0)-(0, 41)))
                       ]))
    }
    
    func testCase623() throws {
        // HTML: <p>foo &lt;!--&gt; foo --&gt;</p>\n<p>foo &lt;!-- foo---&gt;</p>\n
        /* Markdown
         foo <!--> foo -->
         
         foo <!-- foo--->
         
         */
        XCTAssertEqual(try compile("foo <!--> foo -->\n\nfoo <!-- foo--->\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "foo <!–> foo –>", range: (0, 0)-(0, 16)))
                        ],
                        range: (0, 0)-(0, 17))),
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "foo <!– foo—>", range: (2, 0)-(2, 15)))
                        ],
                        range: (2, 0)-(2, 16)))
                       ]))
    }
    
    func testCase624() throws {
        // HTML: <p>foo <?php echo $a; ?></p>\n
        /* Markdown
         foo <?php echo $a; ?>
         
         */
        XCTAssertEqual(try compile("foo <?php echo $a; ?>\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "foo <?php echo $a; ?>", range: (0,0)-(0,20)))
                        ],
                        range: (0, 0)-(0, 21)))
                       ]))
    }
    
    func testCase625() throws {
        // HTML: <p>foo <!ELEMENT br EMPTY></p>\n
        /* Markdown
         foo <!ELEMENT br EMPTY>
         
         */
        XCTAssertEqual(try compile("foo <!ELEMENT br EMPTY>\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "foo <!ELEMENT br EMPTY>", range: (0,0)-(0,22)))
                        ],
                        range: (0, 0)-(0, 23)))
                       ]))
    }
    
    func testCase626() throws {
        // HTML: <p>foo <![CDATA[>&<]]></p>\n
        /* Markdown
         foo <![CDATA[>&<]]>
         
         */
        XCTAssertEqual(try compile("foo <![CDATA[>&<]]>\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "foo <![CDATA[>&<]]>", range: (0,0)-(0,18)))
                        ],
                        range: (0, 0)-(0, 19)))
                       ]))
    }
}
