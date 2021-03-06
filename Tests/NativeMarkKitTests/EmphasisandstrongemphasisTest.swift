import Foundation
import XCTest
@testable import NativeMarkKit

final class EmphasisandstrongemphasisTest: XCTestCase {
    func testCase350() throws {
        // HTML: <p><em>foo bar</em></p>\n
        // Debug: <p><em>foo bar</em></p>\n
        XCTAssertEqual(try compile("*foo bar*\n"),
                       Document(elements: [.paragraph([.emphasis([.text("foo bar")])])]))
    }

    func testCase351() throws {
        // HTML: <p>a * foo bar*</p>\n
        // Debug: <p>a * foo bar*</p>\n
        XCTAssertEqual(try compile("a * foo bar*\n"),
                       Document(elements: [.paragraph([.text("a * foo bar*")])]))
    }

    func testCase352() throws {
        // HTML: <p>a*&quot;foo&quot;*</p>\n
        // Debug: <p>a*&quot;foo&quot;*</p>\n
        XCTAssertEqual(try compile("a*\"foo\"*\n"),
                       Document(elements: [.paragraph([.text("a*“foo”*")])]))
    }

    func testCase353() throws {
        // HTML: <p>* a *</p>\n
        // Debug: <p>* a *</p>\n
        XCTAssertEqual(try compile("* a *\n"),
                       Document(elements: [.paragraph([.text("* a *")])]))
    }

    func testCase354() throws {
        // HTML: <p>foo<em>bar</em></p>\n
        // Debug: <p>foo<em>bar</em></p>\n
        XCTAssertEqual(try compile("foo*bar*\n"),
                       Document(elements: [.paragraph([.text("foo"), .emphasis([.text("bar")])])]))
    }

    func testCase355() throws {
        // HTML: <p>5<em>6</em>78</p>\n
        // Debug: <p>5<em>6</em>78</p>\n
        XCTAssertEqual(try compile("5*6*78\n"),
                       Document(elements: [.paragraph([.text("5"), .emphasis([.text("6")]), .text("78")])]))
    }

    func testCase356() throws {
        // HTML: <p><em>foo bar</em></p>\n
        // Debug: <p><em>foo bar</em></p>\n
        XCTAssertEqual(try compile("_foo bar_\n"),
                       Document(elements: [.paragraph([.emphasis([.text("foo bar")])])]))
    }

    func testCase357() throws {
        // HTML: <p>_ foo bar_</p>\n
        // Debug: <p>_ foo bar_</p>\n
        XCTAssertEqual(try compile("_ foo bar_\n"),
                       Document(elements: [.paragraph([.text("_ foo bar_")])]))
    }

    func testCase358() throws {
        // HTML: <p>a_&quot;foo&quot;_</p>\n
        // Debug: <p>a_&quot;foo&quot;_</p>\n
        XCTAssertEqual(try compile("a_\"foo\"_\n"),
                       Document(elements: [.paragraph([.text("a_“foo”_")])]))
    }

    func testCase359() throws {
        // HTML: <p>foo_bar_</p>\n
        // Debug: <p>foo_bar_</p>\n
        XCTAssertEqual(try compile("foo_bar_\n"),
                       Document(elements: [.paragraph([.text("foo_bar_")])]))
    }

    func testCase360() throws {
        // HTML: <p>5_6_78</p>\n
        // Debug: <p>5_6_78</p>\n
        XCTAssertEqual(try compile("5_6_78\n"),
                       Document(elements: [.paragraph([.text("5_6_78")])]))
    }

    func testCase361() throws {
        // HTML: <p>пристаням_стремятся_</p>\n
        // Debug: <p>пристаням_стремятся_</p>\n
        XCTAssertEqual(try compile("пристаням_стремятся_\n"),
                       Document(elements: [.paragraph([.text("пристаням_стремятся_")])]))
    }

    func testCase362() throws {
        // HTML: <p>aa_&quot;bb&quot;_cc</p>\n
        // Debug: <p>aa_&quot;bb&quot;_cc</p>\n
        XCTAssertEqual(try compile("aa_\"bb\"_cc\n"),
                       Document(elements: [.paragraph([.text("aa_“bb”_cc")])]))
    }

    func testCase363() throws {
        // HTML: <p>foo-<em>(bar)</em></p>\n
        // Debug: <p>foo-<em>(bar)</em></p>\n
        XCTAssertEqual(try compile("foo-_(bar)_\n"),
                       Document(elements: [.paragraph([.text("foo-"), .emphasis([.text("(bar)")])])]))
    }

    func testCase364() throws {
        // HTML: <p>_foo*</p>\n
        // Debug: <p>_foo*</p>\n
        XCTAssertEqual(try compile("_foo*\n"),
                       Document(elements: [.paragraph([.text("_foo*")])]))
    }

    func testCase365() throws {
        // HTML: <p>*foo bar *</p>\n
        // Debug: <p>*foo bar *</p>\n
        XCTAssertEqual(try compile("*foo bar *\n"),
                       Document(elements: [.paragraph([.text("*foo bar *")])]))
    }

    func testCase366() throws {
        // HTML: <p>*foo bar\n*</p>\n
        // Debug: <p>*foo bar\n*</p>\n
        XCTAssertEqual(try compile("*foo bar\n*\n"),
                       Document(elements: [.paragraph([.text("*foo bar"), .softbreak, .text("*")])]))
    }

    func testCase367() throws {
        // HTML: <p>*(*foo)</p>\n
        // Debug: <p>*(*foo)</p>\n
        XCTAssertEqual(try compile("*(*foo)\n"),
                       Document(elements: [.paragraph([.text("*(*foo)")])]))
    }

    func testCase368() throws {
        // HTML: <p><em>(<em>foo</em>)</em></p>\n
        // Debug: <p><em>(<em>foo</em>)</em></p>\n
        XCTAssertEqual(try compile("*(*foo*)*\n"),
                       Document(elements: [.paragraph([.emphasis([.text("("), .emphasis([.text("foo")]), .text(")")])])]))
    }

    func testCase369() throws {
        // HTML: <p><em>foo</em>bar</p>\n
        // Debug: <p><em>foo</em>bar</p>\n
        XCTAssertEqual(try compile("*foo*bar\n"),
                       Document(elements: [.paragraph([.emphasis([.text("foo")]), .text("bar")])]))
    }

    func testCase370() throws {
        // HTML: <p>_foo bar _</p>\n
        // Debug: <p>_foo bar _</p>\n
        XCTAssertEqual(try compile("_foo bar _\n"),
                       Document(elements: [.paragraph([.text("_foo bar _")])]))
    }

    func testCase371() throws {
        // HTML: <p>_(_foo)</p>\n
        // Debug: <p>_(_foo)</p>\n
        XCTAssertEqual(try compile("_(_foo)\n"),
                       Document(elements: [.paragraph([.text("_(_foo)")])]))
    }

    func testCase372() throws {
        // HTML: <p><em>(<em>foo</em>)</em></p>\n
        // Debug: <p><em>(<em>foo</em>)</em></p>\n
        XCTAssertEqual(try compile("_(_foo_)_\n"),
                       Document(elements: [.paragraph([.emphasis([.text("("), .emphasis([.text("foo")]), .text(")")])])]))
    }

    func testCase373() throws {
        // HTML: <p>_foo_bar</p>\n
        // Debug: <p>_foo_bar</p>\n
        XCTAssertEqual(try compile("_foo_bar\n"),
                       Document(elements: [.paragraph([.text("_foo_bar")])]))
    }

    func testCase374() throws {
        // HTML: <p>_пристаням_стремятся</p>\n
        // Debug: <p>_пристаням_стремятся</p>\n
        XCTAssertEqual(try compile("_пристаням_стремятся\n"),
                       Document(elements: [.paragraph([.text("_пристаням_стремятся")])]))
    }

    func testCase375() throws {
        // HTML: <p><em>foo_bar_baz</em></p>\n
        // Debug: <p><em>foo_bar_baz</em></p>\n
        XCTAssertEqual(try compile("_foo_bar_baz_\n"),
                       Document(elements: [.paragraph([.emphasis([.text("foo_bar_baz")])])]))
    }

    func testCase376() throws {
        // HTML: <p><em>(bar)</em>.</p>\n
        // Debug: <p><em>(bar)</em>.</p>\n
        XCTAssertEqual(try compile("_(bar)_.\n"),
                       Document(elements: [.paragraph([.emphasis([.text("(bar)")]), .text(".")])]))
    }

    func testCase377() throws {
        // HTML: <p><strong>foo bar</strong></p>\n
        // Debug: <p><strong>foo bar</strong></p>\n
        XCTAssertEqual(try compile("**foo bar**\n"),
                       Document(elements: [.paragraph([.strong([.text("foo bar")])])]))
    }

    func testCase378() throws {
        // HTML: <p>** foo bar**</p>\n
        // Debug: <p>** foo bar**</p>\n
        XCTAssertEqual(try compile("** foo bar**\n"),
                       Document(elements: [.paragraph([.text("** foo bar**")])]))
    }

    func testCase379() throws {
        // HTML: <p>a**&quot;foo&quot;**</p>\n
        // Debug: <p>a**&quot;foo&quot;**</p>\n
        XCTAssertEqual(try compile("a**\"foo\"**\n"),
                       Document(elements: [.paragraph([.text("a**“foo”**")])]))
    }

    func testCase380() throws {
        // HTML: <p>foo<strong>bar</strong></p>\n
        // Debug: <p>foo<strong>bar</strong></p>\n
        XCTAssertEqual(try compile("foo**bar**\n"),
                       Document(elements: [.paragraph([.text("foo"), .strong([.text("bar")])])]))
    }

    func testCase381() throws {
        // HTML: <p><strong>foo bar</strong></p>\n
        // Debug: <p><strong>foo bar</strong></p>\n
        XCTAssertEqual(try compile("__foo bar__\n"),
                       Document(elements: [.paragraph([.strong([.text("foo bar")])])]))
    }

    func testCase382() throws {
        // HTML: <p>__ foo bar__</p>\n
        // Debug: <p>__ foo bar__</p>\n
        XCTAssertEqual(try compile("__ foo bar__\n"),
                       Document(elements: [.paragraph([.text("__ foo bar__")])]))
    }

    func testCase383() throws {
        // HTML: <p>__\nfoo bar__</p>\n
        // Debug: <p>__\nfoo bar__</p>\n
        XCTAssertEqual(try compile("__\nfoo bar__\n"),
                       Document(elements: [.paragraph([.text("__"), .softbreak, .text("foo bar__")])]))
    }

    func testCase384() throws {
        // HTML: <p>a__&quot;foo&quot;__</p>\n
        // Debug: <p>a__&quot;foo&quot;__</p>\n
        XCTAssertEqual(try compile("a__\"foo\"__\n"),
                       Document(elements: [.paragraph([.text("a__“foo”__")])]))
    }

    func testCase385() throws {
        // HTML: <p>foo__bar__</p>\n
        // Debug: <p>foo__bar__</p>\n
        XCTAssertEqual(try compile("foo__bar__\n"),
                       Document(elements: [.paragraph([.text("foo__bar__")])]))
    }

    func testCase386() throws {
        // HTML: <p>5__6__78</p>\n
        // Debug: <p>5__6__78</p>\n
        XCTAssertEqual(try compile("5__6__78\n"),
                       Document(elements: [.paragraph([.text("5__6__78")])]))
    }

    func testCase387() throws {
        // HTML: <p>пристаням__стремятся__</p>\n
        // Debug: <p>пристаням__стремятся__</p>\n
        XCTAssertEqual(try compile("пристаням__стремятся__\n"),
                       Document(elements: [.paragraph([.text("пристаням__стремятся__")])]))
    }

    func testCase388() throws {
        // HTML: <p><strong>foo, <strong>bar</strong>, baz</strong></p>\n
        // Debug: <p><strong>foo, <strong>bar</strong>, baz</strong></p>\n
        XCTAssertEqual(try compile("__foo, __bar__, baz__\n"),
                       Document(elements: [.paragraph([.strong([.text("foo, "), .strong([.text("bar")]), .text(", baz")])])]))
    }

    func testCase389() throws {
        // HTML: <p>foo-<strong>(bar)</strong></p>\n
        // Debug: <p>foo-<strong>(bar)</strong></p>\n
        XCTAssertEqual(try compile("foo-__(bar)__\n"),
                       Document(elements: [.paragraph([.text("foo-"), .strong([.text("(bar)")])])]))
    }

    func testCase390() throws {
        // HTML: <p>**foo bar **</p>\n
        // Debug: <p>**foo bar **</p>\n
        XCTAssertEqual(try compile("**foo bar **\n"),
                       Document(elements: [.paragraph([.text("**foo bar **")])]))
    }

    func testCase391() throws {
        // HTML: <p>**(**foo)</p>\n
        // Debug: <p>**(**foo)</p>\n
        XCTAssertEqual(try compile("**(**foo)\n"),
                       Document(elements: [.paragraph([.text("**(**foo)")])]))
    }

    func testCase392() throws {
        // HTML: <p><em>(<strong>foo</strong>)</em></p>\n
        // Debug: <p><em>(<strong>foo</strong>)</em></p>\n
        XCTAssertEqual(try compile("*(**foo**)*\n"),
                       Document(elements: [.paragraph([.emphasis([.text("("), .strong([.text("foo")]), .text(")")])])]))
    }

    func testCase393() throws {
        // HTML: <p><strong>Gomphocarpus (<em>Gomphocarpus physocarpus</em>, syn.\n<em>Asclepias physocarpa</em>)</strong></p>\n
        // Debug: <p><strong>Gomphocarpus (<em>Gomphocarpus physocarpus</em>, syn.\n<em>Asclepias physocarpa</em>)</strong></p>\n
        XCTAssertEqual(try compile("**Gomphocarpus (*Gomphocarpus physocarpus*, syn.\n*Asclepias physocarpa*)**\n"),
                       Document(elements: [.paragraph([.strong([.text("Gomphocarpus ("), .emphasis([.text("Gomphocarpus physocarpus")]), .text(", syn."), .softbreak, .emphasis([.text("Asclepias physocarpa")]), .text(")")])])]))
    }

    func testCase394() throws {
        // HTML: <p><strong>foo &quot;<em>bar</em>&quot; foo</strong></p>\n
        // Debug: <p><strong>foo &quot;<em>bar</em>&quot; foo</strong></p>\n
        XCTAssertEqual(try compile("**foo \"*bar*\" foo**\n"),
                       Document(elements: [.paragraph([.strong([.text("foo “"), .emphasis([.text("bar")]), .text("” foo")])])]))
    }

    func testCase395() throws {
        // HTML: <p><strong>foo</strong>bar</p>\n
        // Debug: <p><strong>foo</strong>bar</p>\n
        XCTAssertEqual(try compile("**foo**bar\n"),
                       Document(elements: [.paragraph([.strong([.text("foo")]), .text("bar")])]))
    }

    func testCase396() throws {
        // HTML: <p>__foo bar __</p>\n
        // Debug: <p>__foo bar __</p>\n
        XCTAssertEqual(try compile("__foo bar __\n"),
                       Document(elements: [.paragraph([.text("__foo bar __")])]))
    }

    func testCase397() throws {
        // HTML: <p>__(__foo)</p>\n
        // Debug: <p>__(__foo)</p>\n
        XCTAssertEqual(try compile("__(__foo)\n"),
                       Document(elements: [.paragraph([.text("__(__foo)")])]))
    }

    func testCase398() throws {
        // HTML: <p><em>(<strong>foo</strong>)</em></p>\n
        // Debug: <p><em>(<strong>foo</strong>)</em></p>\n
        XCTAssertEqual(try compile("_(__foo__)_\n"),
                       Document(elements: [.paragraph([.emphasis([.text("("), .strong([.text("foo")]), .text(")")])])]))
    }

    func testCase399() throws {
        // HTML: <p>__foo__bar</p>\n
        // Debug: <p>__foo__bar</p>\n
        XCTAssertEqual(try compile("__foo__bar\n"),
                       Document(elements: [.paragraph([.text("__foo__bar")])]))
    }

    func testCase400() throws {
        // HTML: <p>__пристаням__стремятся</p>\n
        // Debug: <p>__пристаням__стремятся</p>\n
        XCTAssertEqual(try compile("__пристаням__стремятся\n"),
                       Document(elements: [.paragraph([.text("__пристаням__стремятся")])]))
    }

    func testCase401() throws {
        // HTML: <p><strong>foo__bar__baz</strong></p>\n
        // Debug: <p><strong>foo__bar__baz</strong></p>\n
        XCTAssertEqual(try compile("__foo__bar__baz__\n"),
                       Document(elements: [.paragraph([.strong([.text("foo__bar__baz")])])]))
    }

    func testCase402() throws {
        // HTML: <p><strong>(bar)</strong>.</p>\n
        // Debug: <p><strong>(bar)</strong>.</p>\n
        XCTAssertEqual(try compile("__(bar)__.\n"),
                       Document(elements: [.paragraph([.strong([.text("(bar)")]), .text(".")])]))
    }

    func testCase403() throws {
        // HTML: <p><em>foo <a href=\"/url\">bar</a></em></p>\n
        // Debug: <p><em>foo <a href=\"/url\">bar</a></em></p>\n
        XCTAssertEqual(try compile("*foo [bar](/url)*\n"),
                       Document(elements: [.paragraph([.emphasis([.text("foo "), .link(Link(title: "", url: "/url"), text: [.text("bar")])])])]))
    }

    func testCase404() throws {
        // HTML: <p><em>foo\nbar</em></p>\n
        // Debug: <p><em>foo\nbar</em></p>\n
        XCTAssertEqual(try compile("*foo\nbar*\n"),
                       Document(elements: [.paragraph([.emphasis([.text("foo"), .softbreak, .text("bar")])])]))
    }

    func testCase405() throws {
        // HTML: <p><em>foo <strong>bar</strong> baz</em></p>\n
        // Debug: <p><em>foo <strong>bar</strong> baz</em></p>\n
        XCTAssertEqual(try compile("_foo __bar__ baz_\n"),
                       Document(elements: [.paragraph([.emphasis([.text("foo "), .strong([.text("bar")]), .text(" baz")])])]))
    }

    func testCase406() throws {
        // HTML: <p><em>foo <em>bar</em> baz</em></p>\n
        // Debug: <p><em>foo <em>bar</em> baz</em></p>\n
        XCTAssertEqual(try compile("_foo _bar_ baz_\n"),
                       Document(elements: [.paragraph([.emphasis([.text("foo "), .emphasis([.text("bar")]), .text(" baz")])])]))
    }

    func testCase407() throws {
        // HTML: <p><em><em>foo</em> bar</em></p>\n
        // Debug: <p><em><em>foo</em> bar</em></p>\n
        XCTAssertEqual(try compile("__foo_ bar_\n"),
                       Document(elements: [.paragraph([.emphasis([.emphasis([.text("foo")]), .text(" bar")])])]))
    }

    func testCase408() throws {
        // HTML: <p><em>foo <em>bar</em></em></p>\n
        // Debug: <p><em>foo <em>bar</em></em></p>\n
        XCTAssertEqual(try compile("*foo *bar**\n"),
                       Document(elements: [.paragraph([.emphasis([.text("foo "), .emphasis([.text("bar")])])])]))
    }

    func testCase409() throws {
        // HTML: <p><em>foo <strong>bar</strong> baz</em></p>\n
        // Debug: <p><em>foo <strong>bar</strong> baz</em></p>\n
        XCTAssertEqual(try compile("*foo **bar** baz*\n"),
                       Document(elements: [.paragraph([.emphasis([.text("foo "), .strong([.text("bar")]), .text(" baz")])])]))
    }

    func testCase410() throws {
        // HTML: <p><em>foo<strong>bar</strong>baz</em></p>\n
        // Debug: <p><em>foo<strong>bar</strong>baz</em></p>\n
        XCTAssertEqual(try compile("*foo**bar**baz*\n"),
                       Document(elements: [.paragraph([.emphasis([.text("foo"), .strong([.text("bar")]), .text("baz")])])]))
    }

    func testCase411() throws {
        // HTML: <p><em>foo**bar</em></p>\n
        // Debug: <p><em>foo**bar</em></p>\n
        XCTAssertEqual(try compile("*foo**bar*\n"),
                       Document(elements: [.paragraph([.emphasis([.text("foo**bar")])])]))
    }

    func testCase412() throws {
        // HTML: <p><em><strong>foo</strong> bar</em></p>\n
        // Debug: <p><em><strong>foo</strong> bar</em></p>\n
        XCTAssertEqual(try compile("***foo** bar*\n"),
                       Document(elements: [.paragraph([.emphasis([.strong([.text("foo")]), .text(" bar")])])]))
    }

    func testCase413() throws {
        // HTML: <p><em>foo <strong>bar</strong></em></p>\n
        // Debug: <p><em>foo <strong>bar</strong></em></p>\n
        XCTAssertEqual(try compile("*foo **bar***\n"),
                       Document(elements: [.paragraph([.emphasis([.text("foo "), .strong([.text("bar")])])])]))
    }

    func testCase414() throws {
        // HTML: <p><em>foo<strong>bar</strong></em></p>\n
        // Debug: <p><em>foo<strong>bar</strong></em></p>\n
        XCTAssertEqual(try compile("*foo**bar***\n"),
                       Document(elements: [.paragraph([.emphasis([.text("foo"), .strong([.text("bar")])])])]))
    }

    func testCase415() throws {
        // HTML: <p>foo<em><strong>bar</strong></em>baz</p>\n
        // Debug: <p>foo<em><strong>bar</strong></em>baz</p>\n
        XCTAssertEqual(try compile("foo***bar***baz\n"),
                       Document(elements: [.paragraph([.text("foo"), .emphasis([.strong([.text("bar")])]), .text("baz")])]))
    }

    func testCase416() throws {
        // HTML: <p>foo<strong><strong><strong>bar</strong></strong></strong>***baz</p>\n
        // Debug: <p>foo<strong><strong><strong>bar</strong></strong></strong>***baz</p>\n
        XCTAssertEqual(try compile("foo******bar*********baz\n"),
                       Document(elements: [.paragraph([.text("foo"), .strong([.strong([.strong([.text("bar")])])]), .text("***baz")])]))
    }

    func testCase417() throws {
        // HTML: <p><em>foo <strong>bar <em>baz</em> bim</strong> bop</em></p>\n
        // Debug: <p><em>foo <strong>bar <em>baz</em> bim</strong> bop</em></p>\n
        XCTAssertEqual(try compile("*foo **bar *baz* bim** bop*\n"),
                       Document(elements: [.paragraph([.emphasis([.text("foo "), .strong([.text("bar "), .emphasis([.text("baz")]), .text(" bim")]), .text(" bop")])])]))
    }

    func testCase418() throws {
        // HTML: <p><em>foo <a href=\"/url\"><em>bar</em></a></em></p>\n
        // Debug: <p><em>foo <a href=\"/url\"><em>bar</em></a></em></p>\n
        XCTAssertEqual(try compile("*foo [*bar*](/url)*\n"),
                       Document(elements: [.paragraph([.emphasis([.text("foo "), .link(Link(title: "", url: "/url"), text: [.emphasis([.text("bar")])])])])]))
    }

    func testCase419() throws {
        // HTML: <p>** is not an empty emphasis</p>\n
        // Debug: <p>** is not an empty emphasis</p>\n
        XCTAssertEqual(try compile("** is not an empty emphasis\n"),
                       Document(elements: [.paragraph([.text("** is not an empty emphasis")])]))
    }

    func testCase420() throws {
        // HTML: <p>**** is not an empty strong emphasis</p>\n
        // Debug: <p>**** is not an empty strong emphasis</p>\n
        XCTAssertEqual(try compile("**** is not an empty strong emphasis\n"),
                       Document(elements: [.paragraph([.text("**** is not an empty strong emphasis")])]))
    }

    func testCase421() throws {
        // HTML: <p><strong>foo <a href=\"/url\">bar</a></strong></p>\n
        // Debug: <p><strong>foo <a href=\"/url\">bar</a></strong></p>\n
        XCTAssertEqual(try compile("**foo [bar](/url)**\n"),
                       Document(elements: [.paragraph([.strong([.text("foo "), .link(Link(title: "", url: "/url"), text: [.text("bar")])])])]))
    }

    func testCase422() throws {
        // HTML: <p><strong>foo\nbar</strong></p>\n
        // Debug: <p><strong>foo\nbar</strong></p>\n
        XCTAssertEqual(try compile("**foo\nbar**\n"),
                       Document(elements: [.paragraph([.strong([.text("foo"), .softbreak, .text("bar")])])]))
    }

    func testCase423() throws {
        // HTML: <p><strong>foo <em>bar</em> baz</strong></p>\n
        // Debug: <p><strong>foo <em>bar</em> baz</strong></p>\n
        XCTAssertEqual(try compile("__foo _bar_ baz__\n"),
                       Document(elements: [.paragraph([.strong([.text("foo "), .emphasis([.text("bar")]), .text(" baz")])])]))
    }

    func testCase424() throws {
        // HTML: <p><strong>foo <strong>bar</strong> baz</strong></p>\n
        // Debug: <p><strong>foo <strong>bar</strong> baz</strong></p>\n
        XCTAssertEqual(try compile("__foo __bar__ baz__\n"),
                       Document(elements: [.paragraph([.strong([.text("foo "), .strong([.text("bar")]), .text(" baz")])])]))
    }

    func testCase425() throws {
        // HTML: <p><strong><strong>foo</strong> bar</strong></p>\n
        // Debug: <p><strong><strong>foo</strong> bar</strong></p>\n
        XCTAssertEqual(try compile("____foo__ bar__\n"),
                       Document(elements: [.paragraph([.strong([.strong([.text("foo")]), .text(" bar")])])]))
    }

    func testCase426() throws {
        // HTML: <p><strong>foo <strong>bar</strong></strong></p>\n
        // Debug: <p><strong>foo <strong>bar</strong></strong></p>\n
        XCTAssertEqual(try compile("**foo **bar****\n"),
                       Document(elements: [.paragraph([.strong([.text("foo "), .strong([.text("bar")])])])]))
    }

    func testCase427() throws {
        // HTML: <p><strong>foo <em>bar</em> baz</strong></p>\n
        // Debug: <p><strong>foo <em>bar</em> baz</strong></p>\n
        XCTAssertEqual(try compile("**foo *bar* baz**\n"),
                       Document(elements: [.paragraph([.strong([.text("foo "), .emphasis([.text("bar")]), .text(" baz")])])]))
    }

    func testCase428() throws {
        // HTML: <p><strong>foo<em>bar</em>baz</strong></p>\n
        // Debug: <p><strong>foo<em>bar</em>baz</strong></p>\n
        XCTAssertEqual(try compile("**foo*bar*baz**\n"),
                       Document(elements: [.paragraph([.strong([.text("foo"), .emphasis([.text("bar")]), .text("baz")])])]))
    }

    func testCase429() throws {
        // HTML: <p><strong><em>foo</em> bar</strong></p>\n
        // Debug: <p><strong><em>foo</em> bar</strong></p>\n
        XCTAssertEqual(try compile("***foo* bar**\n"),
                       Document(elements: [.paragraph([.strong([.emphasis([.text("foo")]), .text(" bar")])])]))
    }

    func testCase430() throws {
        // HTML: <p><strong>foo <em>bar</em></strong></p>\n
        // Debug: <p><strong>foo <em>bar</em></strong></p>\n
        XCTAssertEqual(try compile("**foo *bar***\n"),
                       Document(elements: [.paragraph([.strong([.text("foo "), .emphasis([.text("bar")])])])]))
    }

    func testCase431() throws {
        // HTML: <p><strong>foo <em>bar <strong>baz</strong>\nbim</em> bop</strong></p>\n
        // Debug: <p><strong>foo <em>bar <strong>baz</strong>\nbim</em> bop</strong></p>\n
        XCTAssertEqual(try compile("**foo *bar **baz**\nbim* bop**\n"),
                       Document(elements: [.paragraph([.strong([.text("foo "), .emphasis([.text("bar "), .strong([.text("baz")]), .softbreak, .text("bim")]), .text(" bop")])])]))
    }

    func testCase432() throws {
        // HTML: <p><strong>foo <a href=\"/url\"><em>bar</em></a></strong></p>\n
        // Debug: <p><strong>foo <a href=\"/url\"><em>bar</em></a></strong></p>\n
        XCTAssertEqual(try compile("**foo [*bar*](/url)**\n"),
                       Document(elements: [.paragraph([.strong([.text("foo "), .link(Link(title: "", url: "/url"), text: [.emphasis([.text("bar")])])])])]))
    }

    func testCase433() throws {
        // HTML: <p>__ is not an empty emphasis</p>\n
        // Debug: <p>__ is not an empty emphasis</p>\n
        XCTAssertEqual(try compile("__ is not an empty emphasis\n"),
                       Document(elements: [.paragraph([.text("__ is not an empty emphasis")])]))
    }

    func testCase434() throws {
        // HTML: <p>____ is not an empty strong emphasis</p>\n
        // Debug: <p>____ is not an empty strong emphasis</p>\n
        XCTAssertEqual(try compile("____ is not an empty strong emphasis\n"),
                       Document(elements: [.paragraph([.text("____ is not an empty strong emphasis")])]))
    }

    func testCase435() throws {
        // HTML: <p>foo ***</p>\n
        // Debug: <p>foo ***</p>\n
        XCTAssertEqual(try compile("foo ***\n"),
                       Document(elements: [.paragraph([.text("foo ***")])]))
    }

    func testCase436() throws {
        // HTML: <p>foo <em>*</em></p>\n
        // Debug: <p>foo <em>*</em></p>\n
        XCTAssertEqual(try compile("foo *\\**\n"),
                       Document(elements: [.paragraph([.text("foo "), .emphasis([.text("*")])])]))
    }

    func testCase437() throws {
        // HTML: <p>foo <em>_</em></p>\n
        // Debug: <p>foo <em>_</em></p>\n
        XCTAssertEqual(try compile("foo *_*\n"),
                       Document(elements: [.paragraph([.text("foo "), .emphasis([.text("_")])])]))
    }

    func testCase438() throws {
        // HTML: <p>foo *****</p>\n
        // Debug: <p>foo *****</p>\n
        XCTAssertEqual(try compile("foo *****\n"),
                       Document(elements: [.paragraph([.text("foo *****")])]))
    }

    func testCase439() throws {
        // HTML: <p>foo <strong>*</strong></p>\n
        // Debug: <p>foo <strong>*</strong></p>\n
        XCTAssertEqual(try compile("foo **\\***\n"),
                       Document(elements: [.paragraph([.text("foo "), .strong([.text("*")])])]))
    }

    func testCase440() throws {
        // HTML: <p>foo <strong>_</strong></p>\n
        // Debug: <p>foo <strong>_</strong></p>\n
        XCTAssertEqual(try compile("foo **_**\n"),
                       Document(elements: [.paragraph([.text("foo "), .strong([.text("_")])])]))
    }

    func testCase441() throws {
        // HTML: <p>*<em>foo</em></p>\n
        // Debug: <p>*<em>foo</em></p>\n
        XCTAssertEqual(try compile("**foo*\n"),
                       Document(elements: [.paragraph([.text("*"), .emphasis([.text("foo")])])]))
    }

    func testCase442() throws {
        // HTML: <p><em>foo</em>*</p>\n
        // Debug: <p><em>foo</em>*</p>\n
        XCTAssertEqual(try compile("*foo**\n"),
                       Document(elements: [.paragraph([.emphasis([.text("foo")]), .text("*")])]))
    }

    func testCase443() throws {
        // HTML: <p>*<strong>foo</strong></p>\n
        // Debug: <p>*<strong>foo</strong></p>\n
        XCTAssertEqual(try compile("***foo**\n"),
                       Document(elements: [.paragraph([.text("*"), .strong([.text("foo")])])]))
    }

    func testCase444() throws {
        // HTML: <p>***<em>foo</em></p>\n
        // Debug: <p>***<em>foo</em></p>\n
        XCTAssertEqual(try compile("****foo*\n"),
                       Document(elements: [.paragraph([.text("***"), .emphasis([.text("foo")])])]))
    }

    func testCase445() throws {
        // HTML: <p><strong>foo</strong>*</p>\n
        // Debug: <p><strong>foo</strong>*</p>\n
        XCTAssertEqual(try compile("**foo***\n"),
                       Document(elements: [.paragraph([.strong([.text("foo")]), .text("*")])]))
    }

    func testCase446() throws {
        // HTML: <p><em>foo</em>***</p>\n
        // Debug: <p><em>foo</em>***</p>\n
        XCTAssertEqual(try compile("*foo****\n"),
                       Document(elements: [.paragraph([.emphasis([.text("foo")]), .text("***")])]))
    }

    func testCase447() throws {
        // HTML: <p>foo ___</p>\n
        // Debug: <p>foo ___</p>\n
        XCTAssertEqual(try compile("foo ___\n"),
                       Document(elements: [.paragraph([.text("foo ___")])]))
    }

    func testCase448() throws {
        // HTML: <p>foo <em>_</em></p>\n
        // Debug: <p>foo <em>_</em></p>\n
        XCTAssertEqual(try compile("foo _\\__\n"),
                       Document(elements: [.paragraph([.text("foo "), .emphasis([.text("_")])])]))
    }

    func testCase449() throws {
        // HTML: <p>foo <em>*</em></p>\n
        // Debug: <p>foo <em>*</em></p>\n
        XCTAssertEqual(try compile("foo _*_\n"),
                       Document(elements: [.paragraph([.text("foo "), .emphasis([.text("*")])])]))
    }

    func testCase450() throws {
        // HTML: <p>foo _____</p>\n
        // Debug: <p>foo _____</p>\n
        XCTAssertEqual(try compile("foo _____\n"),
                       Document(elements: [.paragraph([.text("foo _____")])]))
    }

    func testCase451() throws {
        // HTML: <p>foo <strong>_</strong></p>\n
        // Debug: <p>foo <strong>_</strong></p>\n
        XCTAssertEqual(try compile("foo __\\___\n"),
                       Document(elements: [.paragraph([.text("foo "), .strong([.text("_")])])]))
    }

    func testCase452() throws {
        // HTML: <p>foo <strong>*</strong></p>\n
        // Debug: <p>foo <strong>*</strong></p>\n
        XCTAssertEqual(try compile("foo __*__\n"),
                       Document(elements: [.paragraph([.text("foo "), .strong([.text("*")])])]))
    }

    func testCase453() throws {
        // HTML: <p>_<em>foo</em></p>\n
        // Debug: <p>_<em>foo</em></p>\n
        XCTAssertEqual(try compile("__foo_\n"),
                       Document(elements: [.paragraph([.text("_"), .emphasis([.text("foo")])])]))
    }

    func testCase454() throws {
        // HTML: <p><em>foo</em>_</p>\n
        // Debug: <p><em>foo</em>_</p>\n
        XCTAssertEqual(try compile("_foo__\n"),
                       Document(elements: [.paragraph([.emphasis([.text("foo")]), .text("_")])]))
    }

    func testCase455() throws {
        // HTML: <p>_<strong>foo</strong></p>\n
        // Debug: <p>_<strong>foo</strong></p>\n
        XCTAssertEqual(try compile("___foo__\n"),
                       Document(elements: [.paragraph([.text("_"), .strong([.text("foo")])])]))
    }

    func testCase456() throws {
        // HTML: <p>___<em>foo</em></p>\n
        // Debug: <p>___<em>foo</em></p>\n
        XCTAssertEqual(try compile("____foo_\n"),
                       Document(elements: [.paragraph([.text("___"), .emphasis([.text("foo")])])]))
    }

    func testCase457() throws {
        // HTML: <p><strong>foo</strong>_</p>\n
        // Debug: <p><strong>foo</strong>_</p>\n
        XCTAssertEqual(try compile("__foo___\n"),
                       Document(elements: [.paragraph([.strong([.text("foo")]), .text("_")])]))
    }

    func testCase458() throws {
        // HTML: <p><em>foo</em>___</p>\n
        // Debug: <p><em>foo</em>___</p>\n
        XCTAssertEqual(try compile("_foo____\n"),
                       Document(elements: [.paragraph([.emphasis([.text("foo")]), .text("___")])]))
    }

    func testCase459() throws {
        // HTML: <p><strong>foo</strong></p>\n
        // Debug: <p><strong>foo</strong></p>\n
        XCTAssertEqual(try compile("**foo**\n"),
                       Document(elements: [.paragraph([.strong([.text("foo")])])]))
    }

    func testCase460() throws {
        // HTML: <p><em><em>foo</em></em></p>\n
        // Debug: <p><em><em>foo</em></em></p>\n
        XCTAssertEqual(try compile("*_foo_*\n"),
                       Document(elements: [.paragraph([.emphasis([.emphasis([.text("foo")])])])]))
    }

    func testCase461() throws {
        // HTML: <p><strong>foo</strong></p>\n
        // Debug: <p><strong>foo</strong></p>\n
        XCTAssertEqual(try compile("__foo__\n"),
                       Document(elements: [.paragraph([.strong([.text("foo")])])]))
    }

    func testCase462() throws {
        // HTML: <p><em><em>foo</em></em></p>\n
        // Debug: <p><em><em>foo</em></em></p>\n
        XCTAssertEqual(try compile("_*foo*_\n"),
                       Document(elements: [.paragraph([.emphasis([.emphasis([.text("foo")])])])]))
    }

    func testCase463() throws {
        // HTML: <p><strong><strong>foo</strong></strong></p>\n
        // Debug: <p><strong><strong>foo</strong></strong></p>\n
        XCTAssertEqual(try compile("****foo****\n"),
                       Document(elements: [.paragraph([.strong([.strong([.text("foo")])])])]))
    }

    func testCase464() throws {
        // HTML: <p><strong><strong>foo</strong></strong></p>\n
        // Debug: <p><strong><strong>foo</strong></strong></p>\n
        XCTAssertEqual(try compile("____foo____\n"),
                       Document(elements: [.paragraph([.strong([.strong([.text("foo")])])])]))
    }

    func testCase465() throws {
        // HTML: <p><strong><strong><strong>foo</strong></strong></strong></p>\n
        // Debug: <p><strong><strong><strong>foo</strong></strong></strong></p>\n
        XCTAssertEqual(try compile("******foo******\n"),
                       Document(elements: [.paragraph([.strong([.strong([.strong([.text("foo")])])])])]))
    }

    func testCase466() throws {
        // HTML: <p><em><strong>foo</strong></em></p>\n
        // Debug: <p><em><strong>foo</strong></em></p>\n
        XCTAssertEqual(try compile("***foo***\n"),
                       Document(elements: [.paragraph([.emphasis([.strong([.text("foo")])])])]))
    }

    func testCase467() throws {
        // HTML: <p><em><strong><strong>foo</strong></strong></em></p>\n
        // Debug: <p><em><strong><strong>foo</strong></strong></em></p>\n
        XCTAssertEqual(try compile("_____foo_____\n"),
                       Document(elements: [.paragraph([.emphasis([.strong([.strong([.text("foo")])])])])]))
    }

    func testCase468() throws {
        // HTML: <p><em>foo _bar</em> baz_</p>\n
        // Debug: <p><em>foo _bar</em> baz_</p>\n
        XCTAssertEqual(try compile("*foo _bar* baz_\n"),
                       Document(elements: [.paragraph([.emphasis([.text("foo _bar")]), .text(" baz_")])]))
    }

    func testCase469() throws {
        // HTML: <p><em>foo <strong>bar *baz bim</strong> bam</em></p>\n
        // Debug: <p><em>foo <strong>bar *baz bim</strong> bam</em></p>\n
        XCTAssertEqual(try compile("*foo __bar *baz bim__ bam*\n"),
                       Document(elements: [.paragraph([.emphasis([.text("foo "), .strong([.text("bar *baz bim")]), .text(" bam")])])]))
    }

    func testCase470() throws {
        // HTML: <p>**foo <strong>bar baz</strong></p>\n
        // Debug: <p>**foo <strong>bar baz</strong></p>\n
        XCTAssertEqual(try compile("**foo **bar baz**\n"),
                       Document(elements: [.paragraph([.text("**foo "), .strong([.text("bar baz")])])]))
    }

    func testCase471() throws {
        // HTML: <p>*foo <em>bar baz</em></p>\n
        // Debug: <p>*foo <em>bar baz</em></p>\n
        XCTAssertEqual(try compile("*foo *bar baz*\n"),
                       Document(elements: [.paragraph([.text("*foo "), .emphasis([.text("bar baz")])])]))
    }

    func testCase472() throws {
        // HTML: <p>*<a href=\"/url\">bar*</a></p>\n
        // Debug: <p>*<a href=\"/url\">bar*</a></p>\n
        XCTAssertEqual(try compile("*[bar*](/url)\n"),
                       Document(elements: [.paragraph([.text("*"), .link(Link(title: "", url: "/url"), text: [.text("bar*")])])]))
    }

    func testCase473() throws {
        // HTML: <p>_foo <a href=\"/url\">bar_</a></p>\n
        // Debug: <p>_foo <a href=\"/url\">bar_</a></p>\n
        XCTAssertEqual(try compile("_foo [bar_](/url)\n"),
                       Document(elements: [.paragraph([.text("_foo "), .link(Link(title: "", url: "/url"), text: [.text("bar_")])])]))
    }

    func testCase474() throws {
        // Input: *<img src=\"foo\" title=\"*\"/>\n
        // HTML: <p>*<img src=\"foo\" title=\"*\"/></p>\n
         XCTAssertEqual(try compile("*<img src=\"foo\" title=\"*\"/>\n"),
                        Document(elements: [.paragraph([.text("*<img src=”foo\" title=”*”/>")])]))
    }

    func testCase475() throws {
        // Input: **<a href=\"**\">\n
        // HTML: <p>**<a href=\"**\"></p>\n
         XCTAssertEqual(try compile("**<a href=\"**\">\n"),
                        Document(elements: [.paragraph([.text("**<a href=”**\">")])]))
    }

    func testCase476() throws {
        // Input: __<a href=\"__\">\n
        // HTML: <p>__<a href=\"__\"></p>\n
         XCTAssertEqual(try compile("__<a href=\"__\">\n"),
                        Document(elements: [.paragraph([.text("__<a href=”__\">")])]))
    }

    func testCase477() throws {
        // HTML: <p><em>a <code>*</code></em></p>\n
        // Debug: <p><em>a <code>*</code></em></p>\n
        XCTAssertEqual(try compile("*a `*`*\n"),
                       Document(elements: [.paragraph([.emphasis([.text("a "), .code("*")])])]))
    }

    func testCase478() throws {
        // HTML: <p><em>a <code>_</code></em></p>\n
        // Debug: <p><em>a <code>_</code></em></p>\n
        XCTAssertEqual(try compile("_a `_`_\n"),
                       Document(elements: [.paragraph([.emphasis([.text("a "), .code("_")])])]))
    }

    func testCase479() throws {
        // HTML: <p>**a<a href=\"http://foo.bar/?q=**\">http://foo.bar/?q=**</a></p>\n
        // Debug: <p>**a<a href=\"http://foo.bar/?q=**\">http://foo.bar/?q=**</a></p>\n
        XCTAssertEqual(try compile("**a<http://foo.bar/?q=**>\n"),
                       Document(elements: [.paragraph([.text("**a"), .link(Link(title: "", url: "http://foo.bar/?q=**"), text: [.text("http://foo.bar/?q=**")])])]))
    }

    func testCase480() throws {
        // HTML: <p>__a<a href=\"http://foo.bar/?q=__\">http://foo.bar/?q=__</a></p>\n
        // Debug: <p>__a<a href=\"http://foo.bar/?q=__\">http://foo.bar/?q=__</a></p>\n
        XCTAssertEqual(try compile("__a<http://foo.bar/?q=__>\n"),
                       Document(elements: [.paragraph([.text("__a"), .link(Link(title: "", url: "http://foo.bar/?q=__"), text: [.text("http://foo.bar/?q=__")])])]))
    }

    
}
