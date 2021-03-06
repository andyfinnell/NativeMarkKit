import Foundation
import XCTest
@testable import NativeMarkKit

final class ListsTest: XCTestCase {
    func testCase271() throws {
        // HTML: <ul>\n<li>foo</li>\n<li>bar</li>\n</ul>\n<ul>\n<li>baz</li>\n</ul>\n
        // Debug: <ul>\n<li>{foo caused p to open}foo{debug: implicitly closing p}</li>\n<li>{bar caused p to open}bar{debug: implicitly closing p}</li>\n</ul>\n<ul>\n<li>{baz caused p to open}baz{debug: implicitly closing p}</li>\n</ul>\n
        XCTAssertEqual(try compile("- foo\n- bar\n+ baz\n"),
                       Document(elements: [.list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("foo")])]), ListItem(elements: [.paragraph([.text("bar")])])]), .list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("baz")])])])]))
    }

    func testCase272() throws {
        // HTML: <ol>\n<li>foo</li>\n<li>bar</li>\n</ol>\n<ol start=\"3\">\n<li>baz</li>\n</ol>\n
        // Debug: <ol>\n<li>{foo caused p to open}foo{debug: implicitly closing p}</li>\n<li>{bar caused p to open}bar{debug: implicitly closing p}</li>\n</ol>\n<ol start=\"3\">\n<li>{baz caused p to open}baz{debug: implicitly closing p}</li>\n</ol>\n
        XCTAssertEqual(try compile("1. foo\n2. bar\n3) baz\n"),
                       Document(elements: [.list(ListInfo(isTight: true, kind: .ordered(start: 1)), items: [ListItem(elements: [.paragraph([.text("foo")])]), ListItem(elements: [.paragraph([.text("bar")])])]), .list(ListInfo(isTight: true, kind: .ordered(start: 3)), items: [ListItem(elements: [.paragraph([.text("baz")])])])]))
    }

    func testCase273() throws {
        // HTML: <p>Foo</p>\n<ul>\n<li>bar</li>\n<li>baz</li>\n</ul>\n
        // Debug: <p>Foo</p>\n<ul>\n<li>{bar caused p to open}bar{debug: implicitly closing p}</li>\n<li>{baz caused p to open}baz{debug: implicitly closing p}</li>\n</ul>\n
        XCTAssertEqual(try compile("Foo\n- bar\n- baz\n"),
                       Document(elements: [.paragraph([.text("Foo")]), .list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("bar")])]), ListItem(elements: [.paragraph([.text("baz")])])])]))
    }

    func testCase274() throws {
        // HTML: <p>The number of windows in my house is\n14.  The number of doors is 6.</p>\n
        // Debug: <p>The number of windows in my house is\n14.  The number of doors is 6.</p>\n
        XCTAssertEqual(try compile("The number of windows in my house is\n14.  The number of doors is 6.\n"),
                       Document(elements: [.paragraph([.text("The number of windows in my house is"), .softbreak, .text("14.  The number of doors is 6.")])]))
    }

    func testCase275() throws {
        // HTML: <p>The number of windows in my house is</p>\n<ol>\n<li>The number of doors is 6.</li>\n</ol>\n
        // Debug: <p>The number of windows in my house is</p>\n<ol>\n<li>{The number of doors is 6. caused p to open}The number of doors is 6.{debug: implicitly closing p}</li>\n</ol>\n
        XCTAssertEqual(try compile("The number of windows in my house is\n1.  The number of doors is 6.\n"),
                       Document(elements: [.paragraph([.text("The number of windows in my house is")]), .list(ListInfo(isTight: true, kind: .ordered(start: 1)), items: [ListItem(elements: [.paragraph([.text("The number of doors is 6.")])])])]))
    }

    func testCase276() throws {
        // HTML: <ul>\n<li>\n<p>foo</p>\n</li>\n<li>\n<p>bar</p>\n</li>\n<li>\n<p>baz</p>\n</li>\n</ul>\n
        // Debug: <ul>\n<li>\n<p>foo</p>\n</li>\n<li>\n<p>bar</p>\n</li>\n<li>\n<p>baz</p>\n</li>\n</ul>\n
        XCTAssertEqual(try compile("- foo\n\n- bar\n\n\n- baz\n"),
                       Document(elements: [.list(ListInfo(isTight: false, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("foo")])]), ListItem(elements: [.paragraph([.text("bar")])]), ListItem(elements: [.paragraph([.text("baz")])])])]))
    }

    func testCase277() throws {
        // HTML: <ul>\n<li>foo\n<ul>\n<li>bar\n<ul>\n<li>\n<p>baz</p>\n<p>bim</p>\n</li>\n</ul>\n</li>\n</ul>\n</li>\n</ul>\n
        // Debug: <ul>\n<li>{foo caused p to open}foo\n<ul>\n<li>{bar caused p to open}bar\n<ul>\n<li>\n<p>baz</p>\n<p>bim</p>\n</li>\n</ul>\n</li>\n</ul>\n</li>\n</ul>\n
        XCTAssertEqual(try compile("- foo\n  - bar\n    - baz\n\n\n      bim\n"),
                       Document(elements: [.list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("foo")]), .list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("bar")]), .list(ListInfo(isTight: false, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("baz")]), .paragraph([.text("bim")])])])])])])])]))
    }

    func testCase278() throws {
        // HTML: <ul>\n<li>foo</li>\n<li>bar</li>\n</ul>\n<!-- -->\n<ul>\n<li>baz</li>\n<li>bim</li>\n</ul>\n
        // Debug: <ul>\n<li>{foo caused p to open}foo{debug: implicitly closing p}</li>\n<li>{bar caused p to open}bar{debug: implicitly closing p}</li>\n</ul>\n{<!-- --> caused p to open}<!-- -->\n<ul>\n<li>{baz caused p to open}baz{debug: implicitly closing p}</li>\n<li>{bim caused p to open}bim{debug: implicitly closing p}</li>\n</ul>\n
        XCTAssertEqual(try compile("- foo\n- bar\n\n<!-- -->\n\n- baz\n- bim\n"),
                       Document(elements: [.list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("foo")])]), ListItem(elements: [.paragraph([.text("bar")])])]), .paragraph([.text("<!– –>")]), .list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("baz")])]), ListItem(elements: [.paragraph([.text("bim")])])])]))
    }

    func testCase279() throws {
        // HTML: <ul>\n<li>\n<p>foo</p>\n<p>notcode</p>\n</li>\n<li>\n<p>foo</p>\n</li>\n</ul>\n<!-- -->\n<pre><code>code\n</code></pre>\n
        // Debug: <ul>\n<li>\n<p>foo</p>\n<p>notcode</p>\n</li>\n<li>\n<p>foo</p>\n</li>\n</ul>\n{<!-- --> caused p to open}<!-- -->\n<pre><code>code\n</code></pre>\n{debug: implicitly closing p}
        XCTAssertEqual(try compile("-   foo\n\n    notcode\n\n-   foo\n\n<!-- -->\n\n    code\n"),
                       Document(elements: [.list(ListInfo(isTight: false, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("foo")]), .paragraph([.text("notcode")])]), ListItem(elements: [.paragraph([.text("foo")])])]), .paragraph([.text("<!– –>")]), .codeBlock(infoString: "", content: "code\n")]))
    }

    func testCase280() throws {
        // HTML: <ul>\n<li>a</li>\n<li>b</li>\n<li>c</li>\n<li>d</li>\n<li>e</li>\n<li>f</li>\n<li>g</li>\n</ul>\n
        // Debug: <ul>\n<li>{a caused p to open}a{debug: implicitly closing p}</li>\n<li>{b caused p to open}b{debug: implicitly closing p}</li>\n<li>{c caused p to open}c{debug: implicitly closing p}</li>\n<li>{d caused p to open}d{debug: implicitly closing p}</li>\n<li>{e caused p to open}e{debug: implicitly closing p}</li>\n<li>{f caused p to open}f{debug: implicitly closing p}</li>\n<li>{g caused p to open}g{debug: implicitly closing p}</li>\n</ul>\n
        XCTAssertEqual(try compile("- a\n - b\n  - c\n   - d\n  - e\n - f\n- g\n"),
                       Document(elements: [.list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("a")])]), ListItem(elements: [.paragraph([.text("b")])]), ListItem(elements: [.paragraph([.text("c")])]), ListItem(elements: [.paragraph([.text("d")])]), ListItem(elements: [.paragraph([.text("e")])]), ListItem(elements: [.paragraph([.text("f")])]), ListItem(elements: [.paragraph([.text("g")])])])]))
    }

    func testCase281() throws {
        // HTML: <ol>\n<li>\n<p>a</p>\n</li>\n<li>\n<p>b</p>\n</li>\n<li>\n<p>c</p>\n</li>\n</ol>\n
        // Debug: <ol>\n<li>\n<p>a</p>\n</li>\n<li>\n<p>b</p>\n</li>\n<li>\n<p>c</p>\n</li>\n</ol>\n
        XCTAssertEqual(try compile("1. a\n\n  2. b\n\n   3. c\n"),
                       Document(elements: [.list(ListInfo(isTight: false, kind: .ordered(start: 1)), items: [ListItem(elements: [.paragraph([.text("a")])]), ListItem(elements: [.paragraph([.text("b")])]), ListItem(elements: [.paragraph([.text("c")])])])]))
    }

    func testCase282() throws {
        // HTML: <ul>\n<li>a</li>\n<li>b</li>\n<li>c</li>\n<li>d\n- e</li>\n</ul>\n
        // Debug: <ul>\n<li>{a caused p to open}a{debug: implicitly closing p}</li>\n<li>{b caused p to open}b{debug: implicitly closing p}</li>\n<li>{c caused p to open}c{debug: implicitly closing p}</li>\n<li>{d\n- e caused p to open}d\n- e{debug: implicitly closing p}</li>\n</ul>\n
        XCTAssertEqual(try compile("- a\n - b\n  - c\n   - d\n    - e\n"),
                       Document(elements: [.list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("a")])]), ListItem(elements: [.paragraph([.text("b")])]), ListItem(elements: [.paragraph([.text("c")])]), ListItem(elements: [.paragraph([.text("d"), .softbreak, .text("- e")])])])]))
    }

    func testCase283() throws {
        // HTML: <ol>\n<li>\n<p>a</p>\n</li>\n<li>\n<p>b</p>\n</li>\n</ol>\n<pre><code>3. c\n</code></pre>\n
        // Debug: <ol>\n<li>\n<p>a</p>\n</li>\n<li>\n<p>b</p>\n</li>\n</ol>\n<pre><code>3. c\n</code></pre>\n
        XCTAssertEqual(try compile("1. a\n\n  2. b\n\n    3. c\n"),
                       Document(elements: [.list(ListInfo(isTight: false, kind: .ordered(start: 1)), items: [ListItem(elements: [.paragraph([.text("a")])]), ListItem(elements: [.paragraph([.text("b")])])]), .codeBlock(infoString: "", content: "3. c\n")]))
    }

    func testCase284() throws {
        // HTML: <ul>\n<li>\n<p>a</p>\n</li>\n<li>\n<p>b</p>\n</li>\n<li>\n<p>c</p>\n</li>\n</ul>\n
        // Debug: <ul>\n<li>\n<p>a</p>\n</li>\n<li>\n<p>b</p>\n</li>\n<li>\n<p>c</p>\n</li>\n</ul>\n
        XCTAssertEqual(try compile("- a\n- b\n\n- c\n"),
                       Document(elements: [.list(ListInfo(isTight: false, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("a")])]), ListItem(elements: [.paragraph([.text("b")])]), ListItem(elements: [.paragraph([.text("c")])])])]))
    }

    func testCase285() throws {
        // HTML: <ul>\n<li>\n<p>a</p>\n</li>\n<li></li>\n<li>\n<p>c</p>\n</li>\n</ul>\n
        // Debug: <ul>\n<li>\n<p>a</p>\n</li>\n<li></li>\n<li>\n<p>c</p>\n</li>\n</ul>\n
        XCTAssertEqual(try compile("* a\n*\n\n* c\n"),
                       Document(elements: [.list(ListInfo(isTight: false, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("a")])]), ListItem(elements: []), ListItem(elements: [.paragraph([.text("c")])])])]))
    }

    func testCase286() throws {
        // HTML: <ul>\n<li>\n<p>a</p>\n</li>\n<li>\n<p>b</p>\n<p>c</p>\n</li>\n<li>\n<p>d</p>\n</li>\n</ul>\n
        // Debug: <ul>\n<li>\n<p>a</p>\n</li>\n<li>\n<p>b</p>\n<p>c</p>\n</li>\n<li>\n<p>d</p>\n</li>\n</ul>\n
        XCTAssertEqual(try compile("- a\n- b\n\n  c\n- d\n"),
                       Document(elements: [.list(ListInfo(isTight: false, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("a")])]), ListItem(elements: [.paragraph([.text("b")]), .paragraph([.text("c")])]), ListItem(elements: [.paragraph([.text("d")])])])]))
    }

    func testCase287() throws {
        // HTML: <ul>\n<li>\n<p>a</p>\n</li>\n<li>\n<p>b</p>\n</li>\n<li>\n<p>d</p>\n</li>\n</ul>\n
        // Debug: <ul>\n<li>\n<p>a</p>\n</li>\n<li>\n<p>b</p>\n</li>\n<li>\n<p>d</p>\n</li>\n</ul>\n
        XCTAssertEqual(try compile("- a\n- b\n\n  [ref]: /url\n- d\n"),
                       Document(elements: [.list(ListInfo(isTight: false, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("a")])]), ListItem(elements: [.paragraph([.text("b")])]), ListItem(elements: [.paragraph([.text("d")])])])]))
    }

    func testCase288() throws {
        // HTML: <ul>\n<li>a</li>\n<li>\n<pre><code>b\n\n\n</code></pre>\n</li>\n<li>c</li>\n</ul>\n
        // Debug: <ul>\n<li>{a caused p to open}a{debug: implicitly closing p}</li>\n<li>\n<pre><code>b\n\n\n</code></pre>\n</li>\n<li>{c caused p to open}c{debug: implicitly closing p}</li>\n</ul>\n
        XCTAssertEqual(try compile("- a\n- ```\n  b\n\n\n  ```\n- c\n"),
                       Document(elements: [.list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("a")])]), ListItem(elements: [.codeBlock(infoString: "", content: "b\n\n\n")]), ListItem(elements: [.paragraph([.text("c")])])])]))
    }

    func testCase289() throws {
        // HTML: <ul>\n<li>a\n<ul>\n<li>\n<p>b</p>\n<p>c</p>\n</li>\n</ul>\n</li>\n<li>d</li>\n</ul>\n
        // Debug: <ul>\n<li>{a caused p to open}a\n<ul>\n<li>\n<p>b</p>\n<p>c</p>\n</li>\n</ul>\n</li>\n<li>{d caused p to open}d{debug: implicitly closing p}</li>\n</ul>\n
        XCTAssertEqual(try compile("- a\n  - b\n\n    c\n- d\n"),
                       Document(elements: [.list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("a")]), .list(ListInfo(isTight: false, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("b")]), .paragraph([.text("c")])])])]), ListItem(elements: [.paragraph([.text("d")])])])]))
    }

    func testCase290() throws {
        // HTML: <ul>\n<li>a\n<blockquote>\n<p>b</p>\n</blockquote>\n</li>\n<li>c</li>\n</ul>\n
        // Debug: <ul>\n<li>{a caused p to open}a\n<blockquote>\n<p>b</p>\n</blockquote>\n</li>\n<li>{c caused p to open}c{debug: implicitly closing p}</li>\n</ul>\n
        XCTAssertEqual(try compile("* a\n  > b\n  >\n* c\n"),
                       Document(elements: [.list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("a")]), .blockQuote([.paragraph([.text("b")])])]), ListItem(elements: [.paragraph([.text("c")])])])]))
    }

    func testCase291() throws {
        // HTML: <ul>\n<li>a\n<blockquote>\n<p>b</p>\n</blockquote>\n<pre><code>c\n</code></pre>\n</li>\n<li>d</li>\n</ul>\n
        // Debug: <ul>\n<li>{a caused p to open}a\n<blockquote>\n<p>b</p>\n</blockquote>\n<pre><code>c\n</code></pre>\n</li>\n<li>{d caused p to open}d{debug: implicitly closing p}</li>\n</ul>\n
        XCTAssertEqual(try compile("- a\n  > b\n  ```\n  c\n  ```\n- d\n"),
                       Document(elements: [.list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("a")]), .blockQuote([.paragraph([.text("b")])]), .codeBlock(infoString: "", content: "c\n")]), ListItem(elements: [.paragraph([.text("d")])])])]))
    }

    func testCase292() throws {
        // HTML: <ul>\n<li>a</li>\n</ul>\n
        // Debug: <ul>\n<li>{a caused p to open}a{debug: implicitly closing p}</li>\n</ul>\n
        XCTAssertEqual(try compile("- a\n"),
                       Document(elements: [.list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("a")])])])]))
    }

    func testCase293() throws {
        // HTML: <ul>\n<li>a\n<ul>\n<li>b</li>\n</ul>\n</li>\n</ul>\n
        // Debug: <ul>\n<li>{a caused p to open}a\n<ul>\n<li>{b caused p to open}b{debug: implicitly closing p}</li>\n</ul>\n</li>\n</ul>\n
        XCTAssertEqual(try compile("- a\n  - b\n"),
                       Document(elements: [.list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("a")]), .list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("b")])])])])])]))
    }

    func testCase294() throws {
        // HTML: <ol>\n<li>\n<pre><code>foo\n</code></pre>\n<p>bar</p>\n</li>\n</ol>\n
        // Debug: <ol>\n<li>\n<pre><code>foo\n</code></pre>\n<p>bar</p>\n</li>\n</ol>\n
        XCTAssertEqual(try compile("1. ```\n   foo\n   ```\n\n   bar\n"),
                       Document(elements: [.list(ListInfo(isTight: true, kind: .ordered(start: 1)), items: [ListItem(elements: [.codeBlock(infoString: "", content: "foo\n"), .paragraph([.text("bar")])])])]))
    }

    func testCase295() throws {
        // HTML: <ul>\n<li>\n<p>foo</p>\n<ul>\n<li>bar</li>\n</ul>\n<p>baz</p>\n</li>\n</ul>\n
        // Debug: <ul>\n<li>\n<p>foo</p>\n<ul>\n<li>{bar caused p to open}bar{debug: implicitly closing p}</li>\n</ul>\n<p>baz</p>\n</li>\n</ul>\n
        XCTAssertEqual(try compile("* foo\n  * bar\n\n  baz\n"),
                       Document(elements: [.list(ListInfo(isTight: false, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("foo")]), .list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("bar")])])]), .paragraph([.text("baz")])])])]))
    }

    func testCase296() throws {
        // HTML: <ul>\n<li>\n<p>a</p>\n<ul>\n<li>b</li>\n<li>c</li>\n</ul>\n</li>\n<li>\n<p>d</p>\n<ul>\n<li>e</li>\n<li>f</li>\n</ul>\n</li>\n</ul>\n
        // Debug: <ul>\n<li>\n<p>a</p>\n<ul>\n<li>{b caused p to open}b{debug: implicitly closing p}</li>\n<li>{c caused p to open}c{debug: implicitly closing p}</li>\n</ul>\n</li>\n<li>\n<p>d</p>\n<ul>\n<li>{e caused p to open}e{debug: implicitly closing p}</li>\n<li>{f caused p to open}f{debug: implicitly closing p}</li>\n</ul>\n</li>\n</ul>\n
        XCTAssertEqual(try compile("- a\n  - b\n  - c\n\n- d\n  - e\n  - f\n"),
                       Document(elements: [.list(ListInfo(isTight: false, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("a")]), .list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("b")])]), ListItem(elements: [.paragraph([.text("c")])])])]), ListItem(elements: [.paragraph([.text("d")]), .list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("e")])]), ListItem(elements: [.paragraph([.text("f")])])])])])]))
    }

    
}
