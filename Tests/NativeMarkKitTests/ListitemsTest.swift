import Foundation
import XCTest
@testable import NativeMarkKit

final class ListitemsTest: XCTestCase {
    func testCase223() throws {
        // HTML: <p>A paragraph\nwith two lines.</p>\n<pre><code>indented code\n</code></pre>\n<blockquote>\n<p>A block quote.</p>\n</blockquote>\n
        // Debug: <p>A paragraph\nwith two lines.</p>\n<pre><code>indented code\n</code></pre>\n<blockquote>\n<p>A block quote.</p>\n</blockquote>\n
        XCTAssertEqual(try compile("A paragraph\nwith two lines.\n\n    indented code\n\n> A block quote.\n"),
                       Document(elements: [.paragraph([.text("A paragraph"), .softbreak, .text("with two lines.")]), .codeBlock(infoString: "", content: "indented code\n"), .blockQuote([.paragraph([.text("A block quote.")])])]))
    }

    func testCase224() throws {
        // HTML: <ol>\n<li>\n<p>A paragraph\nwith two lines.</p>\n<pre><code>indented code\n</code></pre>\n<blockquote>\n<p>A block quote.</p>\n</blockquote>\n</li>\n</ol>\n
        // Debug: <ol>\n<li>\n<p>A paragraph\nwith two lines.</p>\n<pre><code>indented code\n</code></pre>\n<blockquote>\n<p>A block quote.</p>\n</blockquote>\n</li>\n</ol>\n
        XCTAssertEqual(try compile("1.  A paragraph\n    with two lines.\n\n        indented code\n\n    > A block quote.\n"),
                       Document(elements: [.list(ListInfo(isTight: false, kind: .ordered(start: 1)), items: [ListItem(elements: [.paragraph([.text("A paragraph"), .softbreak, .text("with two lines.")]), .codeBlock(infoString: "", content: "indented code\n"), .blockQuote([.paragraph([.text("A block quote.")])])])])]))
    }

    func testCase225() throws {
        // HTML: <ul>\n<li>one</li>\n</ul>\n<p>two</p>\n
        // Debug: <ul>\n<li>{one caused p to open}one{debug: implicitly closing p}</li>\n</ul>\n<p>two</p>\n
        XCTAssertEqual(try compile("- one\n\n two\n"),
                       Document(elements: [.list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("one")])])]), .paragraph([.text("two")])]))
    }

    func testCase226() throws {
        // HTML: <ul>\n<li>\n<p>one</p>\n<p>two</p>\n</li>\n</ul>\n
        // Debug: <ul>\n<li>\n<p>one</p>\n<p>two</p>\n</li>\n</ul>\n
        XCTAssertEqual(try compile("- one\n\n  two\n"),
                       Document(elements: [.list(ListInfo(isTight: false, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("one")]), .paragraph([.text("two")])])])]))
    }

    func testCase227() throws {
        // HTML: <ul>\n<li>one</li>\n</ul>\n<pre><code> two\n</code></pre>\n
        // Debug: <ul>\n<li>{one caused p to open}one{debug: implicitly closing p}</li>\n</ul>\n<pre><code> two\n</code></pre>\n
        XCTAssertEqual(try compile(" -    one\n\n     two\n"),
                       Document(elements: [.list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("one")])])]), .codeBlock(infoString: "", content: " two\n")]))
    }

    func testCase228() throws {
        // HTML: <ul>\n<li>\n<p>one</p>\n<p>two</p>\n</li>\n</ul>\n
        // Debug: <ul>\n<li>\n<p>one</p>\n<p>two</p>\n</li>\n</ul>\n
        XCTAssertEqual(try compile(" -    one\n\n      two\n"),
                       Document(elements: [.list(ListInfo(isTight: false, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("one")]), .paragraph([.text("two")])])])]))
    }

    func testCase229() throws {
        // HTML: <blockquote>\n<blockquote>\n<ol>\n<li>\n<p>one</p>\n<p>two</p>\n</li>\n</ol>\n</blockquote>\n</blockquote>\n
        // Debug: <blockquote>\n<blockquote>\n<ol>\n<li>\n<p>one</p>\n<p>two</p>\n</li>\n</ol>\n</blockquote>\n</blockquote>\n
        XCTAssertEqual(try compile("   > > 1.  one\n>>\n>>     two\n"),
                       Document(elements: [.blockQuote([.blockQuote([.list(ListInfo(isTight: false, kind: .ordered(start: 1)), items: [ListItem(elements: [.paragraph([.text("one")]), .paragraph([.text("two")])])])])])]))
    }

    func testCase230() throws {
        // HTML: <blockquote>\n<blockquote>\n<ul>\n<li>one</li>\n</ul>\n<p>two</p>\n</blockquote>\n</blockquote>\n
        // Debug: <blockquote>\n<blockquote>\n<ul>\n<li>{one caused p to open}one{debug: implicitly closing p}</li>\n</ul>\n<p>two</p>\n</blockquote>\n</blockquote>\n
        XCTAssertEqual(try compile(">>- one\n>>\n  >  > two\n"),
                       Document(elements: [.blockQuote([.blockQuote([.list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("one")])])]), .paragraph([.text("two")])])])]))
    }

    func testCase231() throws {
        // HTML: <p>-one</p>\n<p>2.two</p>\n
        // Debug: <p>-one</p>\n<p>2.two</p>\n
        XCTAssertEqual(try compile("-one\n\n2.two\n"),
                       Document(elements: [.paragraph([.text("-one")]), .paragraph([.text("2.two")])]))
    }

    func testCase232() throws {
        // HTML: <ul>\n<li>\n<p>foo</p>\n<p>bar</p>\n</li>\n</ul>\n
        // Debug: <ul>\n<li>\n<p>foo</p>\n<p>bar</p>\n</li>\n</ul>\n
        XCTAssertEqual(try compile("- foo\n\n\n  bar\n"),
                       Document(elements: [.list(ListInfo(isTight: false, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("foo")]), .paragraph([.text("bar")])])])]))
    }

    func testCase233() throws {
        // HTML: <ol>\n<li>\n<p>foo</p>\n<pre><code>bar\n</code></pre>\n<p>baz</p>\n<blockquote>\n<p>bam</p>\n</blockquote>\n</li>\n</ol>\n
        // Debug: <ol>\n<li>\n<p>foo</p>\n<pre><code>bar\n</code></pre>\n<p>baz</p>\n<blockquote>\n<p>bam</p>\n</blockquote>\n</li>\n</ol>\n
        XCTAssertEqual(try compile("1.  foo\n\n    ```\n    bar\n    ```\n\n    baz\n\n    > bam\n"),
                       Document(elements: [.list(ListInfo(isTight: false, kind: .ordered(start: 1)), items: [ListItem(elements: [.paragraph([.text("foo")]), .codeBlock(infoString: "", content: "bar\n"), .paragraph([.text("baz")]), .blockQuote([.paragraph([.text("bam")])])])])]))
    }

    func testCase234() throws {
        // HTML: <ul>\n<li>\n<p>Foo</p>\n<pre><code>bar\n\n\nbaz\n</code></pre>\n</li>\n</ul>\n
        // Debug: <ul>\n<li>\n<p>Foo</p>\n<pre><code>bar\n\n\nbaz\n</code></pre>\n</li>\n</ul>\n
        XCTAssertEqual(try compile("- Foo\n\n      bar\n\n\n      baz\n"),
                       Document(elements: [.list(ListInfo(isTight: false, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("Foo")]), .codeBlock(infoString: "", content: "bar\n\n\nbaz\n")])])]))
    }

    func testCase235() throws {
        // HTML: <ol start=\"123456789\">\n<li>ok</li>\n</ol>\n
        // Debug: <ol start=\"123456789\">\n<li>{ok caused p to open}ok{debug: implicitly closing p}</li>\n</ol>\n
        XCTAssertEqual(try compile("123456789. ok\n"),
                       Document(elements: [.list(ListInfo(isTight: true, kind: .ordered(start: 123456789)), items: [ListItem(elements: [.paragraph([.text("ok")])])])]))
    }

    func testCase236() throws {
        // HTML: <p>1234567890. not ok</p>\n
        // Debug: <p>1234567890. not ok</p>\n
        XCTAssertEqual(try compile("1234567890. not ok\n"),
                       Document(elements: [.paragraph([.text("1234567890. not ok")])]))
    }

    func testCase237() throws {
        // HTML: <ol start=\"0\">\n<li>ok</li>\n</ol>\n
        // Debug: <ol start=\"0\">\n<li>{ok caused p to open}ok{debug: implicitly closing p}</li>\n</ol>\n
        XCTAssertEqual(try compile("0. ok\n"),
                       Document(elements: [.list(ListInfo(isTight: true, kind: .ordered(start: 0)), items: [ListItem(elements: [.paragraph([.text("ok")])])])]))
    }

    func testCase238() throws {
        // HTML: <ol start=\"3\">\n<li>ok</li>\n</ol>\n
        // Debug: <ol start=\"3\">\n<li>{ok caused p to open}ok{debug: implicitly closing p}</li>\n</ol>\n
        XCTAssertEqual(try compile("003. ok\n"),
                       Document(elements: [.list(ListInfo(isTight: true, kind: .ordered(start: 3)), items: [ListItem(elements: [.paragraph([.text("ok")])])])]))
    }

    func testCase239() throws {
        // HTML: <p>-1. not ok</p>\n
        // Debug: <p>-1. not ok</p>\n
        XCTAssertEqual(try compile("-1. not ok\n"),
                       Document(elements: [.paragraph([.text("-1. not ok")])]))
    }

    func testCase240() throws {
        // HTML: <ul>\n<li>\n<p>foo</p>\n<pre><code>bar\n</code></pre>\n</li>\n</ul>\n
        // Debug: <ul>\n<li>\n<p>foo</p>\n<pre><code>bar\n</code></pre>\n</li>\n</ul>\n
        XCTAssertEqual(try compile("- foo\n\n      bar\n"),
                       Document(elements: [.list(ListInfo(isTight: false, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("foo")]), .codeBlock(infoString: "", content: "bar\n")])])]))
    }

    func testCase241() throws {
        // HTML: <ol start=\"10\">\n<li>\n<p>foo</p>\n<pre><code>bar\n</code></pre>\n</li>\n</ol>\n
        // Debug: <ol start=\"10\">\n<li>\n<p>foo</p>\n<pre><code>bar\n</code></pre>\n</li>\n</ol>\n
        XCTAssertEqual(try compile("  10.  foo\n\n           bar\n"),
                       Document(elements: [.list(ListInfo(isTight: false, kind: .ordered(start: 10)), items: [ListItem(elements: [.paragraph([.text("foo")]), .codeBlock(infoString: "", content: "bar\n")])])]))
    }

    func testCase242() throws {
        // HTML: <pre><code>indented code\n</code></pre>\n<p>paragraph</p>\n<pre><code>more code\n</code></pre>\n
        // Debug: <pre><code>indented code\n</code></pre>\n<p>paragraph</p>\n<pre><code>more code\n</code></pre>\n
        XCTAssertEqual(try compile("    indented code\n\nparagraph\n\n    more code\n"),
                       Document(elements: [.codeBlock(infoString: "", content: "indented code\n"), .paragraph([.text("paragraph")]), .codeBlock(infoString: "", content: "more code\n")]))
    }

    func testCase243() throws {
        // HTML: <ol>\n<li>\n<pre><code>indented code\n</code></pre>\n<p>paragraph</p>\n<pre><code>more code\n</code></pre>\n</li>\n</ol>\n
        // Debug: <ol>\n<li>\n<pre><code>indented code\n</code></pre>\n<p>paragraph</p>\n<pre><code>more code\n</code></pre>\n</li>\n</ol>\n
        XCTAssertEqual(try compile("1.     indented code\n\n   paragraph\n\n       more code\n"),
                       Document(elements: [.list(ListInfo(isTight: false, kind: .ordered(start: 1)), items: [ListItem(elements: [.codeBlock(infoString: "", content: "indented code\n"), .paragraph([.text("paragraph")]), .codeBlock(infoString: "", content: "more code\n")])])]))
    }

    func testCase244() throws {
        // HTML: <ol>\n<li>\n<pre><code> indented code\n</code></pre>\n<p>paragraph</p>\n<pre><code>more code\n</code></pre>\n</li>\n</ol>\n
        // Debug: <ol>\n<li>\n<pre><code> indented code\n</code></pre>\n<p>paragraph</p>\n<pre><code>more code\n</code></pre>\n</li>\n</ol>\n
        XCTAssertEqual(try compile("1.      indented code\n\n   paragraph\n\n       more code\n"),
                       Document(elements: [.list(ListInfo(isTight: false, kind: .ordered(start: 1)), items: [ListItem(elements: [.codeBlock(infoString: "", content: " indented code\n"), .paragraph([.text("paragraph")]), .codeBlock(infoString: "", content: "more code\n")])])]))
    }

    func testCase245() throws {
        // HTML: <p>foo</p>\n<p>bar</p>\n
        // Debug: <p>foo</p>\n<p>bar</p>\n
        XCTAssertEqual(try compile("   foo\n\nbar\n"),
                       Document(elements: [.paragraph([.text("foo")]), .paragraph([.text("bar")])]))
    }

    func testCase246() throws {
        // HTML: <ul>\n<li>foo</li>\n</ul>\n<p>bar</p>\n
        // Debug: <ul>\n<li>{foo caused p to open}foo{debug: implicitly closing p}</li>\n</ul>\n<p>bar</p>\n
        XCTAssertEqual(try compile("-    foo\n\n  bar\n"),
                       Document(elements: [.list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("foo")])])]), .paragraph([.text("bar")])]))
    }

    func testCase247() throws {
        // HTML: <ul>\n<li>\n<p>foo</p>\n<p>bar</p>\n</li>\n</ul>\n
        // Debug: <ul>\n<li>\n<p>foo</p>\n<p>bar</p>\n</li>\n</ul>\n
        XCTAssertEqual(try compile("-  foo\n\n   bar\n"),
                       Document(elements: [.list(ListInfo(isTight: false, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("foo")]), .paragraph([.text("bar")])])])]))
    }

    func testCase248() throws {
        // HTML: <ul>\n<li>foo</li>\n<li>\n<pre><code>bar\n</code></pre>\n</li>\n<li>\n<pre><code>baz\n</code></pre>\n</li>\n</ul>\n
        // Debug: <ul>\n<li>{foo caused p to open}foo{debug: implicitly closing p}</li>\n<li>\n<pre><code>bar\n</code></pre>\n</li>\n<li>\n<pre><code>baz\n</code></pre>\n</li>\n</ul>\n
        XCTAssertEqual(try compile("-\n  foo\n-\n  ```\n  bar\n  ```\n-\n      baz\n"),
                       Document(elements: [.list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("foo")])]), ListItem(elements: [.codeBlock(infoString: "", content: "bar\n")]), ListItem(elements: [.codeBlock(infoString: "", content: "baz\n")])])]))
    }

    func testCase249() throws {
        // HTML: <ul>\n<li>foo</li>\n</ul>\n
        // Debug: <ul>\n<li>{foo caused p to open}foo{debug: implicitly closing p}</li>\n</ul>\n
        XCTAssertEqual(try compile("-   \n  foo\n"),
                       Document(elements: [.list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("foo")])])])]))
    }

    func testCase250() throws {
        // HTML: <ul>\n<li></li>\n</ul>\n<p>foo</p>\n
        // Debug: <ul>\n<li></li>\n</ul>\n<p>foo</p>\n
        XCTAssertEqual(try compile("-\n\n  foo\n"),
                       Document(elements: [.list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [])]), .paragraph([.text("foo")])]))
    }

    func testCase251() throws {
        // HTML: <ul>\n<li>foo</li>\n<li></li>\n<li>bar</li>\n</ul>\n
        // Debug: <ul>\n<li>{foo caused p to open}foo{debug: implicitly closing p}</li>\n<li></li>\n<li>{bar caused p to open}bar{debug: implicitly closing p}</li>\n</ul>\n
        XCTAssertEqual(try compile("- foo\n-\n- bar\n"),
                       Document(elements: [.list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("foo")])]), ListItem(elements: []), ListItem(elements: [.paragraph([.text("bar")])])])]))
    }

    func testCase252() throws {
        // HTML: <ul>\n<li>foo</li>\n<li></li>\n<li>bar</li>\n</ul>\n
        // Debug: <ul>\n<li>{foo caused p to open}foo{debug: implicitly closing p}</li>\n<li></li>\n<li>{bar caused p to open}bar{debug: implicitly closing p}</li>\n</ul>\n
        XCTAssertEqual(try compile("- foo\n-   \n- bar\n"),
                       Document(elements: [.list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("foo")])]), ListItem(elements: []), ListItem(elements: [.paragraph([.text("bar")])])])]))
    }

    func testCase253() throws {
        // HTML: <ol>\n<li>foo</li>\n<li></li>\n<li>bar</li>\n</ol>\n
        // Debug: <ol>\n<li>{foo caused p to open}foo{debug: implicitly closing p}</li>\n<li></li>\n<li>{bar caused p to open}bar{debug: implicitly closing p}</li>\n</ol>\n
        XCTAssertEqual(try compile("1. foo\n2.\n3. bar\n"),
                       Document(elements: [.list(ListInfo(isTight: true, kind: .ordered(start: 1)), items: [ListItem(elements: [.paragraph([.text("foo")])]), ListItem(elements: []), ListItem(elements: [.paragraph([.text("bar")])])])]))
    }

    func testCase254() throws {
        // HTML: <ul>\n<li></li>\n</ul>\n
        // Debug: <ul>\n<li></li>\n</ul>\n
        XCTAssertEqual(try compile("*\n"),
                       Document(elements: [.list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [])])]))
    }

    func testCase255() throws {
        // HTML: <p>foo\n*</p>\n<p>foo\n1.</p>\n
        // Debug: <p>foo\n*</p>\n<p>foo\n1.</p>\n
        XCTAssertEqual(try compile("foo\n*\n\nfoo\n1.\n"),
                       Document(elements: [.paragraph([.text("foo"), .softbreak, .text("*")]), .paragraph([.text("foo"), .softbreak, .text("1.")])]))
    }

    func testCase256() throws {
        // HTML: <ol>\n<li>\n<p>A paragraph\nwith two lines.</p>\n<pre><code>indented code\n</code></pre>\n<blockquote>\n<p>A block quote.</p>\n</blockquote>\n</li>\n</ol>\n
        // Debug: <ol>\n<li>\n<p>A paragraph\nwith two lines.</p>\n<pre><code>indented code\n</code></pre>\n<blockquote>\n<p>A block quote.</p>\n</blockquote>\n</li>\n</ol>\n
        XCTAssertEqual(try compile(" 1.  A paragraph\n     with two lines.\n\n         indented code\n\n     > A block quote.\n"),
                       Document(elements: [.list(ListInfo(isTight: false, kind: .ordered(start: 1)), items: [ListItem(elements: [.paragraph([.text("A paragraph"), .softbreak, .text("with two lines.")]), .codeBlock(infoString: "", content: "indented code\n"), .blockQuote([.paragraph([.text("A block quote.")])])])])]))
    }

    func testCase257() throws {
        // HTML: <ol>\n<li>\n<p>A paragraph\nwith two lines.</p>\n<pre><code>indented code\n</code></pre>\n<blockquote>\n<p>A block quote.</p>\n</blockquote>\n</li>\n</ol>\n
        // Debug: <ol>\n<li>\n<p>A paragraph\nwith two lines.</p>\n<pre><code>indented code\n</code></pre>\n<blockquote>\n<p>A block quote.</p>\n</blockquote>\n</li>\n</ol>\n
        XCTAssertEqual(try compile("  1.  A paragraph\n      with two lines.\n\n          indented code\n\n      > A block quote.\n"),
                       Document(elements: [.list(ListInfo(isTight: false, kind: .ordered(start: 1)), items: [ListItem(elements: [.paragraph([.text("A paragraph"), .softbreak, .text("with two lines.")]), .codeBlock(infoString: "", content: "indented code\n"), .blockQuote([.paragraph([.text("A block quote.")])])])])]))
    }

    func testCase258() throws {
        // HTML: <ol>\n<li>\n<p>A paragraph\nwith two lines.</p>\n<pre><code>indented code\n</code></pre>\n<blockquote>\n<p>A block quote.</p>\n</blockquote>\n</li>\n</ol>\n
        // Debug: <ol>\n<li>\n<p>A paragraph\nwith two lines.</p>\n<pre><code>indented code\n</code></pre>\n<blockquote>\n<p>A block quote.</p>\n</blockquote>\n</li>\n</ol>\n
        XCTAssertEqual(try compile("   1.  A paragraph\n       with two lines.\n\n           indented code\n\n       > A block quote.\n"),
                       Document(elements: [.list(ListInfo(isTight: false, kind: .ordered(start: 1)), items: [ListItem(elements: [.paragraph([.text("A paragraph"), .softbreak, .text("with two lines.")]), .codeBlock(infoString: "", content: "indented code\n"), .blockQuote([.paragraph([.text("A block quote.")])])])])]))
    }

    func testCase259() throws {
        // HTML: <pre><code>1.  A paragraph\n    with two lines.\n\n        indented code\n\n    &gt; A block quote.\n</code></pre>\n
        // Debug: <pre><code>1.  A paragraph\n    with two lines.\n\n        indented code\n\n    &gt; A block quote.\n</code></pre>\n
        XCTAssertEqual(try compile("    1.  A paragraph\n        with two lines.\n\n            indented code\n\n        > A block quote.\n"),
                       Document(elements: [.codeBlock(infoString: "", content: "1.  A paragraph\n    with two lines.\n\n        indented code\n\n    > A block quote.\n")]))
    }

    func testCase260() throws {
        // HTML: <ol>\n<li>\n<p>A paragraph\nwith two lines.</p>\n<pre><code>indented code\n</code></pre>\n<blockquote>\n<p>A block quote.</p>\n</blockquote>\n</li>\n</ol>\n
        // Debug: <ol>\n<li>\n<p>A paragraph\nwith two lines.</p>\n<pre><code>indented code\n</code></pre>\n<blockquote>\n<p>A block quote.</p>\n</blockquote>\n</li>\n</ol>\n
        XCTAssertEqual(try compile("  1.  A paragraph\nwith two lines.\n\n          indented code\n\n      > A block quote.\n"),
                       Document(elements: [.list(ListInfo(isTight: false, kind: .ordered(start: 1)), items: [ListItem(elements: [.paragraph([.text("A paragraph"), .softbreak, .text("with two lines.")]), .codeBlock(infoString: "", content: "indented code\n"), .blockQuote([.paragraph([.text("A block quote.")])])])])]))
    }

    func testCase261() throws {
        // HTML: <ol>\n<li>A paragraph\nwith two lines.</li>\n</ol>\n
        // Debug: <ol>\n<li>{A paragraph\nwith two lines. caused p to open}A paragraph\nwith two lines.{debug: implicitly closing p}</li>\n</ol>\n
        XCTAssertEqual(try compile("  1.  A paragraph\n    with two lines.\n"),
                       Document(elements: [.list(ListInfo(isTight: true, kind: .ordered(start: 1)), items: [ListItem(elements: [.paragraph([.text("A paragraph"), .softbreak, .text("with two lines.")])])])]))
    }

    func testCase262() throws {
        // HTML: <blockquote>\n<ol>\n<li>\n<blockquote>\n<p>Blockquote\ncontinued here.</p>\n</blockquote>\n</li>\n</ol>\n</blockquote>\n
        // Debug: <blockquote>\n<ol>\n<li>\n<blockquote>\n<p>Blockquote\ncontinued here.</p>\n</blockquote>\n</li>\n</ol>\n</blockquote>\n
        XCTAssertEqual(try compile("> 1. > Blockquote\ncontinued here.\n"),
                       Document(elements: [.blockQuote([.list(ListInfo(isTight: true, kind: .ordered(start: 1)), items: [ListItem(elements: [.blockQuote([.paragraph([.text("Blockquote"), .softbreak, .text("continued here.")])])])])])]))
    }

    func testCase263() throws {
        // HTML: <blockquote>\n<ol>\n<li>\n<blockquote>\n<p>Blockquote\ncontinued here.</p>\n</blockquote>\n</li>\n</ol>\n</blockquote>\n
        // Debug: <blockquote>\n<ol>\n<li>\n<blockquote>\n<p>Blockquote\ncontinued here.</p>\n</blockquote>\n</li>\n</ol>\n</blockquote>\n
        XCTAssertEqual(try compile("> 1. > Blockquote\n> continued here.\n"),
                       Document(elements: [.blockQuote([.list(ListInfo(isTight: true, kind: .ordered(start: 1)), items: [ListItem(elements: [.blockQuote([.paragraph([.text("Blockquote"), .softbreak, .text("continued here.")])])])])])]))
    }

    func testCase264() throws {
        // HTML: <ul>\n<li>foo\n<ul>\n<li>bar\n<ul>\n<li>baz\n<ul>\n<li>boo</li>\n</ul>\n</li>\n</ul>\n</li>\n</ul>\n</li>\n</ul>\n
        // Debug: <ul>\n<li>{foo caused p to open}foo\n<ul>\n<li>{bar caused p to open}bar\n<ul>\n<li>{baz caused p to open}baz\n<ul>\n<li>{boo caused p to open}boo{debug: implicitly closing p}</li>\n</ul>\n</li>\n</ul>\n</li>\n</ul>\n</li>\n</ul>\n
        XCTAssertEqual(try compile("- foo\n  - bar\n    - baz\n      - boo\n"),
                       Document(elements: [.list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("foo")]), .list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("bar")]), .list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("baz")]), .list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("boo")])])])])])])])])])]))
    }

    func testCase265() throws {
        // HTML: <ul>\n<li>foo</li>\n<li>bar</li>\n<li>baz</li>\n<li>boo</li>\n</ul>\n
        // Debug: <ul>\n<li>{foo caused p to open}foo{debug: implicitly closing p}</li>\n<li>{bar caused p to open}bar{debug: implicitly closing p}</li>\n<li>{baz caused p to open}baz{debug: implicitly closing p}</li>\n<li>{boo caused p to open}boo{debug: implicitly closing p}</li>\n</ul>\n
        XCTAssertEqual(try compile("- foo\n - bar\n  - baz\n   - boo\n"),
                       Document(elements: [.list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("foo")])]), ListItem(elements: [.paragraph([.text("bar")])]), ListItem(elements: [.paragraph([.text("baz")])]), ListItem(elements: [.paragraph([.text("boo")])])])]))
    }

    func testCase266() throws {
        // HTML: <ol start=\"10\">\n<li>foo\n<ul>\n<li>bar</li>\n</ul>\n</li>\n</ol>\n
        // Debug: <ol start=\"10\">\n<li>{foo caused p to open}foo\n<ul>\n<li>{bar caused p to open}bar{debug: implicitly closing p}</li>\n</ul>\n</li>\n</ol>\n
        XCTAssertEqual(try compile("10) foo\n    - bar\n"),
                       Document(elements: [.list(ListInfo(isTight: true, kind: .ordered(start: 10)), items: [ListItem(elements: [.paragraph([.text("foo")]), .list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("bar")])])])])])]))
    }

    func testCase267() throws {
        // HTML: <ol start=\"10\">\n<li>foo</li>\n</ol>\n<ul>\n<li>bar</li>\n</ul>\n
        // Debug: <ol start=\"10\">\n<li>{foo caused p to open}foo{debug: implicitly closing p}</li>\n</ol>\n<ul>\n<li>{bar caused p to open}bar{debug: implicitly closing p}</li>\n</ul>\n
        XCTAssertEqual(try compile("10) foo\n   - bar\n"),
                       Document(elements: [.list(ListInfo(isTight: true, kind: .ordered(start: 10)), items: [ListItem(elements: [.paragraph([.text("foo")])])]), .list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("bar")])])])]))
    }

    func testCase268() throws {
        // HTML: <ul>\n<li>\n<ul>\n<li>foo</li>\n</ul>\n</li>\n</ul>\n
        // Debug: <ul>\n<li>\n<ul>\n<li>{foo caused p to open}foo{debug: implicitly closing p}</li>\n</ul>\n</li>\n</ul>\n
        XCTAssertEqual(try compile("- - foo\n"),
                       Document(elements: [.list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.paragraph([.text("foo")])])])])])]))
    }

    func testCase269() throws {
        // HTML: <ol>\n<li>\n<ul>\n<li>\n<ol start=\"2\">\n<li>foo</li>\n</ol>\n</li>\n</ul>\n</li>\n</ol>\n
        // Debug: <ol>\n<li>\n<ul>\n<li>\n<ol start=\"2\">\n<li>{foo caused p to open}foo{debug: implicitly closing p}</li>\n</ol>\n</li>\n</ul>\n</li>\n</ol>\n
        XCTAssertEqual(try compile("1. - 2. foo\n"),
                       Document(elements: [.list(ListInfo(isTight: true, kind: .ordered(start: 1)), items: [ListItem(elements: [.list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.list(ListInfo(isTight: true, kind: .ordered(start: 2)), items: [ListItem(elements: [.paragraph([.text("foo")])])])])])])])]))
    }

    func testCase270() throws {
        // HTML: <ul>\n<li>\n<h1>Foo</h1>\n</li>\n<li>\n<h2>Bar</h2>\nbaz</li>\n</ul>\n
        // Debug: <ul>\n<li>\n<h1>Foo</h1>\n</li>\n<li>\n<h2>Bar</h2>{baz caused p to open}\nbaz{debug: implicitly closing p}</li>\n</ul>\n
        XCTAssertEqual(try compile("- # Foo\n- Bar\n  ---\n  baz\n"),
                       Document(elements: [.list(ListInfo(isTight: true, kind: .bulleted), items: [ListItem(elements: [.heading(level: 1, text: [.text("Foo")])]), ListItem(elements: [.heading(level: 2, text: [.text("Bar")]), .paragraph([.text("baz")])])])]))
    }

    
}
