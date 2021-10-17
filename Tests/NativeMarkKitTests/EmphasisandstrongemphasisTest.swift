import Foundation
import XCTest
@testable import NativeMarkKit

final class EmphasisandstrongemphasisTest: XCTestCase {
    func testCase350() throws {
        // HTML: <p><em>foo bar</em></p>\n
        /* Markdown
         *foo bar*
         
         */
        XCTAssertEqual(try compile("*foo bar*\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .emphasis(InlineEmphasis(text: [
                                .text(InlineString(text: "foo bar", range: (0,1)-(0,7)))
                            ],
                            range:(0, 0)-(0, 8)))
                        ],
                        range: (0, 0)-(0, 9)))
                       ]))
    }
    
    func testCase351() throws {
        // HTML: <p>a * foo bar*</p>\n
        /* Markdown
         a * foo bar*
         
         */
        XCTAssertEqual(try compile("a * foo bar*\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "a * foo bar*", range: (0,0)-(0,11)))
                        ],
                        range: (0, 0)-(0, 12)))
                       ]))
    }
    
    func testCase352() throws {
        // HTML: <p>a*&quot;foo&quot;*</p>\n
        /* Markdown
         a*"foo"*
         
         */
        XCTAssertEqual(try compile("a*\"foo\"*\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "a*“foo”*", range: (0, 0)-(0, 7)))
                        ],
                        range: (0, 0)-(0, 8)))
                       ]))
    }
    
    func testCase353() throws {
        // HTML: <p>* a *</p>\n
        /* Markdown
         * a *
         
         */
        XCTAssertEqual(try compile("* a *\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "* a *", range: (0,0)-(0,4)))
                        ],
                        range: (0, 0)-(0, 5)))
                       ]))
    }
    
    func testCase354() throws {
        // HTML: <p>foo<em>bar</em></p>\n
        /* Markdown
         foo*bar*
         
         */
        XCTAssertEqual(try compile("foo*bar*\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "foo", range: (0,0)-(0,2))),
                            .emphasis(InlineEmphasis(text: [
                                .text(InlineString(text: "bar", range: (0,4)-(0,6)))
                            ],
                            range:(0, 3)-(0, 7)))
                        ],
                        range: (0, 0)-(0, 8)))
                       ]))
    }
    
    func testCase355() throws {
        // HTML: <p>5<em>6</em>78</p>\n
        /* Markdown
         5*6*78
         
         */
        XCTAssertEqual(try compile("5*6*78\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "5", range: (0,0)-(0,0))),
                            .emphasis(InlineEmphasis(text: [
                                .text(InlineString(text: "6", range: (0,2)-(0,2)))
                            ],
                            range:(0, 1)-(0, 3))),
                            .text(InlineString(text: "78", range: (0,4)-(0,5)))
                        ],
                        range: (0, 0)-(0, 6)))
                       ]))
    }
    
    func testCase356() throws {
        // HTML: <p><em>foo bar</em></p>\n
        /* Markdown
         _foo bar_
         
         */
        XCTAssertEqual(try compile("_foo bar_\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .emphasis(InlineEmphasis(text: [
                                .text(InlineString(text: "foo bar", range: (0,1)-(0,7)))
                            ],
                            range:(0, 0)-(0, 8)))
                        ],
                        range: (0, 0)-(0, 9)))
                       ]))
    }
    
    func testCase357() throws {
        // HTML: <p>_ foo bar_</p>\n
        /* Markdown
         _ foo bar_
         
         */
        XCTAssertEqual(try compile("_ foo bar_\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "_ foo bar_", range: (0,0)-(0,9)))
                        ],
                        range: (0, 0)-(0, 10)))
                       ]))
    }
    
    func testCase358() throws {
        // HTML: <p>a_&quot;foo&quot;_</p>\n
        /* Markdown
         a_"foo"_
         
         */
        XCTAssertEqual(try compile("a_\"foo\"_\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "a_“foo”_", range: (0, 0)-(0, 7)))
                        ],
                        range: (0, 0)-(0, 8)))
                       ]))
    }
    
    func testCase359() throws {
        // HTML: <p>foo_bar_</p>\n
        /* Markdown
         foo_bar_
         
         */
        XCTAssertEqual(try compile("foo_bar_\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "foo_bar_", range: (0,0)-(0,7)))
                        ],
                        range: (0, 0)-(0, 8)))
                       ]))
    }
    
    func testCase360() throws {
        // HTML: <p>5_6_78</p>\n
        /* Markdown
         5_6_78
         
         */
        XCTAssertEqual(try compile("5_6_78\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "5_6_78", range: (0,0)-(0,5)))
                        ],
                        range: (0, 0)-(0, 6)))
                       ]))
    }
    
    func testCase361() throws {
        // HTML: <p>пристаням_стремятся_</p>\n
        /* Markdown
         пристаням_стремятся_
         
         */
        XCTAssertEqual(try compile("пристаням_стремятся_\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "пристаням_стремятся_", range: (0,0)-(0,19)))
                        ],
                        range: (0, 0)-(0, 20)))
                       ]))
    }
    
    func testCase362() throws {
        // HTML: <p>aa_&quot;bb&quot;_cc</p>\n
        /* Markdown
         aa_"bb"_cc
         
         */
        XCTAssertEqual(try compile("aa_\"bb\"_cc\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "aa_“bb”_cc", range: (0, 0)-(0, 9)))
                        ],
                        range: (0, 0)-(0, 10)))
                       ]))
    }
    
    func testCase363() throws {
        // HTML: <p>foo-<em>(bar)</em></p>\n
        /* Markdown
         foo-_(bar)_
         
         */
        XCTAssertEqual(try compile("foo-_(bar)_\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "foo-", range: (0,0)-(0,3))),
                            .emphasis(InlineEmphasis(text: [
                                .text(InlineString(text: "(bar)", range: (0,5)-(0,9)))
                            ],
                            range:(0, 4)-(0, 10)))
                        ],
                        range: (0, 0)-(0, 11)))
                       ]))
    }
    
    func testCase364() throws {
        // HTML: <p>_foo*</p>\n
        /* Markdown
         _foo*
         
         */
        XCTAssertEqual(try compile("_foo*\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "_foo*", range: (0,0)-(0,4)))
                        ],
                        range: (0, 0)-(0, 5)))
                       ]))
    }
    
    func testCase365() throws {
        // HTML: <p>*foo bar *</p>\n
        /* Markdown
         *foo bar *
         
         */
        XCTAssertEqual(try compile("*foo bar *\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "*foo bar *", range: (0,0)-(0,9)))
                        ],
                        range: (0, 0)-(0, 10)))
                       ]))
    }
    
    func testCase366() throws {
        // HTML: <p>*foo bar\n*</p>\n
        /* Markdown
         *foo bar
         *
         
         */
        XCTAssertEqual(try compile("*foo bar\n*\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "*foo bar", range: (0,0)-(0,7))),
                            .softbreak(InlineSoftbreak(range: (0, 8)-(0, 8))),
                            .text(InlineString(text: "*", range: (1,0)-(1,0)))
                        ],
                        range: (0, 0)-(1, 1)))
                       ]))
    }
    
    func testCase367() throws {
        // HTML: <p>*(*foo)</p>\n
        /* Markdown
         *(*foo)
         
         */
        XCTAssertEqual(try compile("*(*foo)\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "*(*foo)", range: (0,0)-(0,6)))
                        ],
                        range: (0, 0)-(0, 7)))
                       ]))
    }
    
    func testCase368() throws {
        // HTML: <p><em>(<em>foo</em>)</em></p>\n
        /* Markdown
         *(*foo*)*
         
         */
        XCTAssertEqual(try compile("*(*foo*)*\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .emphasis(InlineEmphasis(text: [
                                .text(InlineString(text: "(", range: (0,1)-(0,1))),
                                .emphasis(InlineEmphasis(text: [
                                    .text(InlineString(text: "foo", range: (0,3)-(0,5)))
                                ],
                                range:(0, 2)-(0, 6))),
                                .text(InlineString(text: ")", range: (0,7)-(0,7)))
                            ],
                            range:(0, 0)-(0, 8)))
                        ],
                        range: (0, 0)-(0, 9)))
                       ]))
    }
    
    func testCase369() throws {
        // HTML: <p><em>foo</em>bar</p>\n
        /* Markdown
         *foo*bar
         
         */
        XCTAssertEqual(try compile("*foo*bar\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .emphasis(InlineEmphasis(text: [
                                .text(InlineString(text: "foo", range: (0,1)-(0,3)))
                            ],
                            range:(0, 0)-(0, 4))),
                            .text(InlineString(text: "bar", range: (0,5)-(0,7)))
                        ],
                        range: (0, 0)-(0, 8)))
                       ]))
    }
    
    func testCase370() throws {
        // HTML: <p>_foo bar _</p>\n
        /* Markdown
         _foo bar _
         
         */
        XCTAssertEqual(try compile("_foo bar _\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "_foo bar _", range: (0,0)-(0,9)))
                        ],
                        range: (0, 0)-(0, 10)))
                       ]))
    }
    
    func testCase371() throws {
        // HTML: <p>_(_foo)</p>\n
        /* Markdown
         _(_foo)
         
         */
        XCTAssertEqual(try compile("_(_foo)\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "_(_foo)", range: (0,0)-(0,6)))
                        ],
                        range: (0, 0)-(0, 7)))
                       ]))
    }
    
    func testCase372() throws {
        // HTML: <p><em>(<em>foo</em>)</em></p>\n
        /* Markdown
         _(_foo_)_
         
         */
        XCTAssertEqual(try compile("_(_foo_)_\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .emphasis(InlineEmphasis(text: [
                                .text(InlineString(text: "(", range: (0,1)-(0,1))),
                                .emphasis(InlineEmphasis(text: [
                                    .text(InlineString(text: "foo", range: (0,3)-(0,5)))
                                ],
                                range:(0, 2)-(0, 6))),
                                .text(InlineString(text: ")", range: (0,7)-(0,7)))
                            ],
                            range:(0, 0)-(0, 8)))
                        ],
                        range: (0, 0)-(0, 9)))
                       ]))
    }
    
    func testCase373() throws {
        // HTML: <p>_foo_bar</p>\n
        /* Markdown
         _foo_bar
         
         */
        XCTAssertEqual(try compile("_foo_bar\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "_foo_bar", range: (0,0)-(0,7)))
                        ],
                        range: (0, 0)-(0, 8)))
                       ]))
    }
    
    func testCase374() throws {
        // HTML: <p>_пристаням_стремятся</p>\n
        /* Markdown
         _пристаням_стремятся
         
         */
        XCTAssertEqual(try compile("_пристаням_стремятся\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "_пристаням_стремятся", range: (0,0)-(0,19)))
                        ],
                        range: (0, 0)-(0, 20)))
                       ]))
    }
    
    func testCase375() throws {
        // HTML: <p><em>foo_bar_baz</em></p>\n
        /* Markdown
         _foo_bar_baz_
         
         */
        XCTAssertEqual(try compile("_foo_bar_baz_\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .emphasis(InlineEmphasis(text: [
                                .text(InlineString(text: "foo_bar_baz", range: (0,1)-(0,11)))
                            ],
                            range:(0, 0)-(0, 12)))
                        ],
                        range: (0, 0)-(0, 13)))
                       ]))
    }
    
    func testCase376() throws {
        // HTML: <p><em>(bar)</em>.</p>\n
        /* Markdown
         _(bar)_.
         
         */
        XCTAssertEqual(try compile("_(bar)_.\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .emphasis(InlineEmphasis(text: [
                                .text(InlineString(text: "(bar)", range: (0,1)-(0,5)))
                            ],
                            range:(0, 0)-(0, 6))),
                            .text(InlineString(text: ".", range: (0,7)-(0,7)))
                        ],
                        range: (0, 0)-(0, 8)))
                       ]))
    }
    
    func testCase377() throws {
        // HTML: <p><strong>foo bar</strong></p>\n
        /* Markdown
         **foo bar**
         
         */
        XCTAssertEqual(try compile("**foo bar**\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .strong(InlineStrong(text: [
                                .text(InlineString(text: "foo bar", range: (0,2)-(0,8)))
                            ],
                            range:(0, 0)-(0, 10)))
                        ],
                        range: (0, 0)-(0, 11)))
                       ]))
    }
    
    func testCase378() throws {
        // HTML: <p>** foo bar**</p>\n
        /* Markdown
         ** foo bar**
         
         */
        XCTAssertEqual(try compile("** foo bar**\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "** foo bar**", range: (0,0)-(0,11)))
                        ],
                        range: (0, 0)-(0, 12)))
                       ]))
    }
    
    func testCase379() throws {
        // HTML: <p>a**&quot;foo&quot;**</p>\n
        /* Markdown
         a**"foo"**
         
         */
        XCTAssertEqual(try compile("a**\"foo\"**\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "a**“foo”**", range: (0, 0)-(0, 9)))
                        ],
                        range: (0, 0)-(0, 10)))
                       ]))
    }
    
    func testCase380() throws {
        // HTML: <p>foo<strong>bar</strong></p>\n
        /* Markdown
         foo**bar**
         
         */
        XCTAssertEqual(try compile("foo**bar**\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "foo", range: (0,0)-(0,2))),
                            .strong(InlineStrong(text: [
                                .text(InlineString(text: "bar", range: (0,5)-(0,7)))
                            ],
                            range:(0, 3)-(0, 9)))
                        ],
                        range: (0, 0)-(0, 10)))
                       ]))
    }
    
    func testCase381() throws {
        // HTML: <p><strong>foo bar</strong></p>\n
        /* Markdown
         __foo bar__
         
         */
        XCTAssertEqual(try compile("__foo bar__\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .strong(InlineStrong(text: [
                                .text(InlineString(text: "foo bar", range: (0,2)-(0,8)))
                            ],
                            range:(0, 0)-(0, 10)))
                        ],
                        range: (0, 0)-(0, 11)))
                       ]))
    }
    
    func testCase382() throws {
        // HTML: <p>__ foo bar__</p>\n
        /* Markdown
         __ foo bar__
         
         */
        XCTAssertEqual(try compile("__ foo bar__\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "__ foo bar__", range: (0,0)-(0,11)))
                        ],
                        range: (0, 0)-(0, 12)))
                       ]))
    }
    
    func testCase383() throws {
        // HTML: <p>__\nfoo bar__</p>\n
        /* Markdown
         __
         foo bar__
         
         */
        XCTAssertEqual(try compile("__\nfoo bar__\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "__", range: (0,0)-(0,1))),
                            .softbreak(InlineSoftbreak(range: (0, 2)-(0, 2))),
                            .text(InlineString(text: "foo bar__", range: (1,0)-(1,8)))
                        ],
                        range: (0, 0)-(1, 9)))
                       ]))
    }
    
    func testCase384() throws {
        // HTML: <p>a__&quot;foo&quot;__</p>\n
        /* Markdown
         a__"foo"__
         
         */
        XCTAssertEqual(try compile("a__\"foo\"__\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "a__“foo”__", range: (0, 0)-(0, 9)))
                        ],
                        range: (0, 0)-(0, 10)))
                       ]))
    }
    
    func testCase385() throws {
        // HTML: <p>foo__bar__</p>\n
        /* Markdown
         foo__bar__
         
         */
        XCTAssertEqual(try compile("foo__bar__\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "foo__bar__", range: (0,0)-(0,9)))
                        ],
                        range: (0, 0)-(0, 10)))
                       ]))
    }
    
    func testCase386() throws {
        // HTML: <p>5__6__78</p>\n
        /* Markdown
         5__6__78
         
         */
        XCTAssertEqual(try compile("5__6__78\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "5__6__78", range: (0,0)-(0,7)))
                        ],
                        range: (0, 0)-(0, 8)))
                       ]))
    }
    
    func testCase387() throws {
        // HTML: <p>пристаням__стремятся__</p>\n
        /* Markdown
         пристаням__стремятся__
         
         */
        XCTAssertEqual(try compile("пристаням__стремятся__\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "пристаням__стремятся__", range: (0,0)-(0,21)))
                        ],
                        range: (0, 0)-(0, 22)))
                       ]))
    }
    
    func testCase388() throws {
        // HTML: <p><strong>foo, <strong>bar</strong>, baz</strong></p>\n
        /* Markdown
         __foo, __bar__, baz__
         
         */
        XCTAssertEqual(try compile("__foo, __bar__, baz__\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .strong(InlineStrong(text: [
                                .text(InlineString(text: "foo, ", range: (0,2)-(0,6))),
                                .strong(InlineStrong(text: [
                                    .text(InlineString(text: "bar", range: (0,9)-(0,11)))
                                ],
                                range:(0, 7)-(0, 13))),
                                .text(InlineString(text: ", baz", range: (0,14)-(0,18)))
                            ],
                            range:(0, 0)-(0, 20)))
                        ],
                        range: (0, 0)-(0, 21)))
                       ]))
    }
    
    func testCase389() throws {
        // HTML: <p>foo-<strong>(bar)</strong></p>\n
        /* Markdown
         foo-__(bar)__
         
         */
        XCTAssertEqual(try compile("foo-__(bar)__\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "foo-", range: (0,0)-(0,3))),
                            .strong(InlineStrong(text: [
                                .text(InlineString(text: "(bar)", range: (0,6)-(0,10)))
                            ],
                            range:(0, 4)-(0, 12)))
                        ],
                        range: (0, 0)-(0, 13)))
                       ]))
    }
    
    func testCase390() throws {
        // HTML: <p>**foo bar **</p>\n
        /* Markdown
         **foo bar **
         
         */
        XCTAssertEqual(try compile("**foo bar **\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "**foo bar **", range: (0,0)-(0,11)))
                        ],
                        range: (0, 0)-(0, 12)))
                       ]))
    }
    
    func testCase391() throws {
        // HTML: <p>**(**foo)</p>\n
        /* Markdown
         **(**foo)
         
         */
        XCTAssertEqual(try compile("**(**foo)\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "**(**foo)", range: (0,0)-(0,8)))
                        ],
                        range: (0, 0)-(0, 9)))
                       ]))
    }
    
    func testCase392() throws {
        // HTML: <p><em>(<strong>foo</strong>)</em></p>\n
        /* Markdown
         *(**foo**)*
         
         */
        XCTAssertEqual(try compile("*(**foo**)*\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .emphasis(InlineEmphasis(text: [
                                .text(InlineString(text: "(", range: (0,1)-(0,1))),
                                .strong(InlineStrong(text: [
                                    .text(InlineString(text: "foo", range: (0,4)-(0,6)))
                                ],
                                range:(0, 2)-(0, 8))),
                                .text(InlineString(text: ")", range: (0,9)-(0,9)))
                            ],
                            range:(0, 0)-(0, 10)))
                        ],
                        range: (0, 0)-(0, 11)))
                       ]))
    }
    
    func testCase393() throws {
        // HTML: <p><strong>Gomphocarpus (<em>Gomphocarpus physocarpus</em>, syn.\n<em>Asclepias physocarpa</em>)</strong></p>\n
        /* Markdown
         **Gomphocarpus (*Gomphocarpus physocarpus*, syn.
         *Asclepias physocarpa*)**
         
         */
        XCTAssertEqual(try compile("**Gomphocarpus (*Gomphocarpus physocarpus*, syn.\n*Asclepias physocarpa*)**\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .strong(InlineStrong(text: [
                                .text(InlineString(text: "Gomphocarpus (", range: (0,2)-(0,15))),
                                .emphasis(InlineEmphasis(text: [
                                    .text(InlineString(text: "Gomphocarpus physocarpus", range: (0,17)-(0,40)))
                                ],
                                range:(0, 16)-(0, 41))),
                                .text(InlineString(text: ", syn.", range: (0,42)-(0,47))),
                                .softbreak(InlineSoftbreak(range: (0, 48)-(0, 48))),
                                .emphasis(InlineEmphasis(text: [
                                    .text(InlineString(text: "Asclepias physocarpa", range: (1,1)-(1,20)))
                                ],
                                range:(1, 0)-(1, 21))),
                                .text(InlineString(text: ")", range: (1,22)-(1,22)))
                            ],
                            range:(0, 0)-(1, 24)))
                        ],
                        range: (0, 0)-(1, 25)))
                       ]))
    }
    
    func testCase394() throws {
        // HTML: <p><strong>foo &quot;<em>bar</em>&quot; foo</strong></p>\n
        /* Markdown
         **foo "*bar*" foo**
         
         */
        XCTAssertEqual(try compile("**foo \"*bar*\" foo**\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .strong(InlineStrong(text: [
                                .text(InlineString(text: "foo “", range: (0, 2)-(0, 6))),
                                .emphasis(InlineEmphasis(text: [
                                    .text(InlineString(text: "bar", range: (0,8)-(0,10)))
                                ],
                                range:(0, 7)-(0, 11))),
                                .text(InlineString(text: "” foo", range: (0, 12)-(0, 16)))
                            ],
                            range:(0, 0)-(0, 18)))
                        ],
                        range: (0, 0)-(0, 19)))
                       ]))
    }
    
    func testCase395() throws {
        // HTML: <p><strong>foo</strong>bar</p>\n
        /* Markdown
         **foo**bar
         
         */
        XCTAssertEqual(try compile("**foo**bar\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .strong(InlineStrong(text: [
                                .text(InlineString(text: "foo", range: (0,2)-(0,4)))
                            ],
                            range:(0, 0)-(0, 6))),
                            .text(InlineString(text: "bar", range: (0,7)-(0,9)))
                        ],
                        range: (0, 0)-(0, 10)))
                       ]))
    }
    
    func testCase396() throws {
        // HTML: <p>__foo bar __</p>\n
        /* Markdown
         __foo bar __
         
         */
        XCTAssertEqual(try compile("__foo bar __\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "__foo bar __", range: (0,0)-(0,11)))
                        ],
                        range: (0, 0)-(0, 12)))
                       ]))
    }
    
    func testCase397() throws {
        // HTML: <p>__(__foo)</p>\n
        /* Markdown
         __(__foo)
         
         */
        XCTAssertEqual(try compile("__(__foo)\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "__(__foo)", range: (0,0)-(0,8)))
                        ],
                        range: (0, 0)-(0, 9)))
                       ]))
    }
    
    func testCase398() throws {
        // HTML: <p><em>(<strong>foo</strong>)</em></p>\n
        /* Markdown
         _(__foo__)_
         
         */
        XCTAssertEqual(try compile("_(__foo__)_\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .emphasis(InlineEmphasis(text: [
                                .text(InlineString(text: "(", range: (0,1)-(0,1))),
                                .strong(InlineStrong(text: [
                                    .text(InlineString(text: "foo", range: (0,4)-(0,6)))
                                ],
                                range:(0, 2)-(0, 8))),
                                .text(InlineString(text: ")", range: (0,9)-(0,9)))
                            ],
                            range:(0, 0)-(0, 10)))
                        ],
                        range: (0, 0)-(0, 11)))
                       ]))
    }
    
    func testCase399() throws {
        // HTML: <p>__foo__bar</p>\n
        /* Markdown
         __foo__bar
         
         */
        XCTAssertEqual(try compile("__foo__bar\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "__foo__bar", range: (0,0)-(0,9)))
                        ],
                        range: (0, 0)-(0, 10)))
                       ]))
    }
    
    func testCase400() throws {
        // HTML: <p>__пристаням__стремятся</p>\n
        /* Markdown
         __пристаням__стремятся
         
         */
        XCTAssertEqual(try compile("__пристаням__стремятся\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "__пристаням__стремятся", range: (0,0)-(0,21)))
                        ],
                        range: (0, 0)-(0, 22)))
                       ]))
    }
    
    func testCase401() throws {
        // HTML: <p><strong>foo__bar__baz</strong></p>\n
        /* Markdown
         __foo__bar__baz__
         
         */
        XCTAssertEqual(try compile("__foo__bar__baz__\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .strong(InlineStrong(text: [
                                .text(InlineString(text: "foo__bar__baz", range: (0,2)-(0,14)))
                            ],
                            range:(0, 0)-(0, 16)))
                        ],
                        range: (0, 0)-(0, 17)))
                       ]))
    }
    
    func testCase402() throws {
        // HTML: <p><strong>(bar)</strong>.</p>\n
        /* Markdown
         __(bar)__.
         
         */
        XCTAssertEqual(try compile("__(bar)__.\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .strong(InlineStrong(text: [
                                .text(InlineString(text: "(bar)", range: (0,2)-(0,6)))
                            ],
                            range:(0, 0)-(0, 8))),
                            .text(InlineString(text: ".", range: (0,9)-(0,9)))
                        ],
                        range: (0, 0)-(0, 10)))
                       ]))
    }
    
    func testCase403() throws {
        // HTML: <p><em>foo <a href=\"/url\">bar</a></em></p>\n
        /* Markdown
         *foo [bar](/url)*
         
         */
        XCTAssertEqual(try compile("*foo [bar](/url)*\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .emphasis(InlineEmphasis(text: [
                                .text(InlineString(text: "foo ", range: (0,1)-(0,4))),
                                .link(InlineLink(link: Link(title: nil,
                                                            url: InlineString(text: "/url", range: (0, 11)-(0, 14))),
                                                 text: [
                                                    .text(InlineString(text: "bar", range: (0,6)-(0,8)))
                                                 ],
                                                 range: (0, 5)-(0, 15)))
                            ],
                            range:(0, 0)-(0, 16)))
                        ],
                        range: (0, 0)-(0, 17)))
                       ]))
    }
    
    func testCase404() throws {
        // HTML: <p><em>foo\nbar</em></p>\n
        /* Markdown
         *foo
         bar*
         
         */
        XCTAssertEqual(try compile("*foo\nbar*\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .emphasis(InlineEmphasis(text: [
                                .text(InlineString(text: "foo", range: (0,1)-(0,3))),
                                .softbreak(InlineSoftbreak(range: (0, 4)-(0, 4))),
                                .text(InlineString(text: "bar", range: (1,0)-(1,2)))
                            ],
                            range:(0, 0)-(1, 3)))
                        ],
                        range: (0, 0)-(1, 4)))
                       ]))
    }
    
    func testCase405() throws {
        // HTML: <p><em>foo <strong>bar</strong> baz</em></p>\n
        /* Markdown
         _foo __bar__ baz_
         
         */
        XCTAssertEqual(try compile("_foo __bar__ baz_\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .emphasis(InlineEmphasis(text: [
                                .text(InlineString(text: "foo ", range: (0,1)-(0,4))),
                                .strong(InlineStrong(text: [
                                    .text(InlineString(text: "bar", range: (0,7)-(0,9)))
                                ],
                                range:(0, 5)-(0, 11))),
                                .text(InlineString(text: " baz", range: (0,12)-(0,15)))
                            ],
                            range:(0, 0)-(0, 16)))
                        ],
                        range: (0, 0)-(0, 17)))
                       ]))
    }
    
    func testCase406() throws {
        // HTML: <p><em>foo <em>bar</em> baz</em></p>\n
        /* Markdown
         _foo _bar_ baz_
         
         */
        XCTAssertEqual(try compile("_foo _bar_ baz_\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .emphasis(InlineEmphasis(text: [
                                .text(InlineString(text: "foo ", range: (0,1)-(0,4))),
                                .emphasis(InlineEmphasis(text: [
                                    .text(InlineString(text: "bar", range: (0,6)-(0,8)))
                                ],
                                range:(0, 5)-(0, 9))),
                                .text(InlineString(text: " baz", range: (0,10)-(0,13)))
                            ],
                            range:(0, 0)-(0, 14)))
                        ],
                        range: (0, 0)-(0, 15)))
                       ]))
    }
    
    func testCase407() throws {
        // HTML: <p><em><em>foo</em> bar</em></p>\n
        /* Markdown
         __foo_ bar_
         
         */
        XCTAssertEqual(try compile("__foo_ bar_\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .emphasis(InlineEmphasis(text: [
                                .emphasis(InlineEmphasis(text: [
                                    .text(InlineString(text: "foo", range: (0,2)-(0,4)))
                                ],
                                range:(0, 1)-(0, 5))),
                                .text(InlineString(text: " bar", range: (0,6)-(0,9)))
                            ],
                            range:(0, 0)-(0, 10)))
                        ],
                        range: (0, 0)-(0, 11)))
                       ]))
    }
    
    func testCase408() throws {
        // HTML: <p><em>foo <em>bar</em></em></p>\n
        /* Markdown
         *foo *bar**
         
         */
        XCTAssertEqual(try compile("*foo *bar**\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .emphasis(InlineEmphasis(text: [
                                .text(InlineString(text: "foo ", range: (0,1)-(0,4))),
                                .emphasis(InlineEmphasis(text: [
                                    .text(InlineString(text: "bar", range: (0,6)-(0,8)))
                                ],
                                range:(0, 5)-(0, 9)))
                            ],
                            range:(0, 0)-(0, 10)))
                        ],
                        range: (0, 0)-(0, 11)))
                       ]))
    }
    
    func testCase409() throws {
        // HTML: <p><em>foo <strong>bar</strong> baz</em></p>\n
        /* Markdown
         *foo **bar** baz*
         
         */
        XCTAssertEqual(try compile("*foo **bar** baz*\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .emphasis(InlineEmphasis(text: [
                                .text(InlineString(text: "foo ", range: (0,1)-(0,4))),
                                .strong(InlineStrong(text: [
                                    .text(InlineString(text: "bar", range: (0,7)-(0,9)))
                                ],
                                range:(0, 5)-(0, 11))),
                                .text(InlineString(text: " baz", range: (0,12)-(0,15)))
                            ],
                            range:(0, 0)-(0, 16)))
                        ],
                        range: (0, 0)-(0, 17)))
                       ]))
    }
    
    func testCase410() throws {
        // HTML: <p><em>foo<strong>bar</strong>baz</em></p>\n
        /* Markdown
         *foo**bar**baz*
         
         */
        XCTAssertEqual(try compile("*foo**bar**baz*\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .emphasis(InlineEmphasis(text: [
                                .text(InlineString(text: "foo", range: (0,1)-(0,3))),
                                .strong(InlineStrong(text: [
                                    .text(InlineString(text: "bar", range: (0,6)-(0,8)))
                                ],
                                range:(0, 4)-(0, 10))),
                                .text(InlineString(text: "baz", range: (0,11)-(0,13)))
                            ],
                            range:(0, 0)-(0, 14)))
                        ],
                        range: (0, 0)-(0, 15)))
                       ]))
    }
    
    func testCase411() throws {
        // HTML: <p><em>foo**bar</em></p>\n
        /* Markdown
         *foo**bar*
         
         */
        XCTAssertEqual(try compile("*foo**bar*\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .emphasis(InlineEmphasis(text: [
                                .text(InlineString(text: "foo**bar", range: (0,1)-(0,8)))
                            ],
                            range:(0, 0)-(0, 9)))
                        ],
                        range: (0, 0)-(0, 10)))
                       ]))
    }
    
    func testCase412() throws {
        // HTML: <p><em><strong>foo</strong> bar</em></p>\n
        /* Markdown
         ***foo** bar*
         
         */
        XCTAssertEqual(try compile("***foo** bar*\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .emphasis(InlineEmphasis(text: [
                                .strong(InlineStrong(text: [
                                    .text(InlineString(text: "foo", range: (0,3)-(0,5)))
                                ],
                                range:(0, 1)-(0, 7))),
                                .text(InlineString(text: " bar", range: (0,8)-(0,11)))
                            ],
                            range:(0, 0)-(0, 12)))
                        ],
                        range: (0, 0)-(0, 13)))
                       ]))
    }
    
    func testCase413() throws {
        // HTML: <p><em>foo <strong>bar</strong></em></p>\n
        /* Markdown
         *foo **bar***
         
         */
        XCTAssertEqual(try compile("*foo **bar***\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .emphasis(InlineEmphasis(text: [
                                .text(InlineString(text: "foo ", range: (0,1)-(0,4))),
                                .strong(InlineStrong(text: [
                                    .text(InlineString(text: "bar", range: (0,7)-(0,9)))
                                ],
                                range:(0, 5)-(0, 11)))
                            ],
                            range:(0, 0)-(0, 12)))
                        ],
                        range: (0, 0)-(0, 13)))
                       ]))
    }
    
    func testCase414() throws {
        // HTML: <p><em>foo<strong>bar</strong></em></p>\n
        /* Markdown
         *foo**bar***
         
         */
        XCTAssertEqual(try compile("*foo**bar***\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .emphasis(InlineEmphasis(text: [
                                .text(InlineString(text: "foo", range: (0,1)-(0,3))),
                                .strong(InlineStrong(text: [
                                    .text(InlineString(text: "bar", range: (0,6)-(0,8)))
                                ],
                                range:(0, 4)-(0, 10)))
                            ],
                            range:(0, 0)-(0, 11)))
                        ],
                        range: (0, 0)-(0, 12)))
                       ]))
    }
    
    func testCase415() throws {
        // HTML: <p>foo<em><strong>bar</strong></em>baz</p>\n
        /* Markdown
         foo***bar***baz
         
         */
        XCTAssertEqual(try compile("foo***bar***baz\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "foo", range: (0,0)-(0,2))),
                            .emphasis(InlineEmphasis(text: [
                                .strong(InlineStrong(text: [
                                    .text(InlineString(text: "bar", range: (0,6)-(0,8)))
                                ],
                                range:(0, 4)-(0, 10)))
                            ],
                            range:(0, 3)-(0, 11))),
                            .text(InlineString(text: "baz", range: (0,12)-(0,14)))
                        ],
                        range: (0, 0)-(0, 15)))
                       ]))
    }
    
    func testCase416() throws {
        // HTML: <p>foo<strong><strong><strong>bar</strong></strong></strong>***baz</p>\n
        /* Markdown
         foo******bar*********baz
         
         */
        XCTAssertEqual(try compile("foo******bar*********baz\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "foo", range: (0,0)-(0,2))),
                            .strong(InlineStrong(text: [
                                .strong(InlineStrong(text: [
                                    .strong(InlineStrong(text: [
                                        .text(InlineString(text: "bar", range: (0,9)-(0,11)))
                                    ],
                                    range:(0, 7)-(0, 13)))
                                ],
                                range:(0, 5)-(0, 15)))
                            ],
                            range:(0, 3)-(0, 17))),
                            .text(InlineString(text: "***baz", range: (0,18)-(0,23)))
                        ],
                        range: (0, 0)-(0, 24)))
                       ]))
    }
    
    func testCase417() throws {
        // HTML: <p><em>foo <strong>bar <em>baz</em> bim</strong> bop</em></p>\n
        /* Markdown
         *foo **bar *baz* bim** bop*
         
         */
        XCTAssertEqual(try compile("*foo **bar *baz* bim** bop*\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .emphasis(InlineEmphasis(text: [
                                .text(InlineString(text: "foo ", range: (0,1)-(0,4))),
                                .strong(InlineStrong(text: [
                                    .text(InlineString(text: "bar ", range: (0,7)-(0,10))),
                                    .emphasis(InlineEmphasis(text: [
                                        .text(InlineString(text: "baz", range: (0,12)-(0,14)))
                                    ],
                                    range:(0, 11)-(0, 15))),
                                    .text(InlineString(text: " bim", range: (0,16)-(0,19)))
                                ],
                                range:(0, 5)-(0, 21))),
                                .text(InlineString(text: " bop", range: (0,22)-(0,25)))
                            ],
                            range:(0, 0)-(0, 26)))
                        ],
                        range: (0, 0)-(0, 27)))
                       ]))
    }
    
    func testCase418() throws {
        // HTML: <p><em>foo <a href=\"/url\"><em>bar</em></a></em></p>\n
        /* Markdown
         *foo [*bar*](/url)*
         
         */
        XCTAssertEqual(try compile("*foo [*bar*](/url)*\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .emphasis(InlineEmphasis(text: [
                                .text(InlineString(text: "foo ", range: (0,1)-(0,4))),
                                .link(InlineLink(link: Link(title: nil,
                                                            url: InlineString(text: "/url", range: (0, 13)-(0, 16))),
                                                 text: [
                                                    .emphasis(InlineEmphasis(text: [
                                                        .text(InlineString(text: "bar", range: (0,7)-(0,9)))
                                                    ],
                                                    range:(0, 6)-(0, 10)))
                                                 ],
                                                 range: (0, 5)-(0, 17)))
                            ],
                            range:(0, 0)-(0, 18)))
                        ],
                        range: (0, 0)-(0, 19)))
                       ]))
    }
    
    func testCase419() throws {
        // HTML: <p>** is not an empty emphasis</p>\n
        /* Markdown
         ** is not an empty emphasis
         
         */
        XCTAssertEqual(try compile("** is not an empty emphasis\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "** is not an empty emphasis", range: (0,0)-(0,26)))
                        ],
                        range: (0, 0)-(0, 27)))
                       ]))
    }
    
    func testCase420() throws {
        // HTML: <p>**** is not an empty strong emphasis</p>\n
        /* Markdown
         **** is not an empty strong emphasis
         
         */
        XCTAssertEqual(try compile("**** is not an empty strong emphasis\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "**** is not an empty strong emphasis", range: (0,0)-(0,35)))
                        ],
                        range: (0, 0)-(0, 36)))
                       ]))
    }
    
    func testCase421() throws {
        // HTML: <p><strong>foo <a href=\"/url\">bar</a></strong></p>\n
        /* Markdown
         **foo [bar](/url)**
         
         */
        XCTAssertEqual(try compile("**foo [bar](/url)**\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .strong(InlineStrong(text: [
                                .text(InlineString(text: "foo ", range: (0,2)-(0,5))),
                                .link(InlineLink(link: Link(title: nil,
                                                            url: InlineString(text: "/url", range: (0, 12)-(0, 15))),
                                                 text: [
                                                    .text(InlineString(text: "bar", range: (0,7)-(0,9)))
                                                 ],
                                                 range: (0, 6)-(0, 16)))
                            ],
                            range:(0, 0)-(0, 18)))
                        ],
                        range: (0, 0)-(0, 19)))
                       ]))
    }
    
    func testCase422() throws {
        // HTML: <p><strong>foo\nbar</strong></p>\n
        /* Markdown
         **foo
         bar**
         
         */
        XCTAssertEqual(try compile("**foo\nbar**\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .strong(InlineStrong(text: [
                                .text(InlineString(text: "foo", range: (0,2)-(0,4))),
                                .softbreak(InlineSoftbreak(range: (0, 5)-(0, 5))),
                                .text(InlineString(text: "bar", range: (1,0)-(1,2)))
                            ],
                            range:(0, 0)-(1, 4)))
                        ],
                        range: (0, 0)-(1, 5)))
                       ]))
    }
    
    func testCase423() throws {
        // HTML: <p><strong>foo <em>bar</em> baz</strong></p>\n
        /* Markdown
         __foo _bar_ baz__
         
         */
        XCTAssertEqual(try compile("__foo _bar_ baz__\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .strong(InlineStrong(text: [
                                .text(InlineString(text: "foo ", range: (0,2)-(0,5))),
                                .emphasis(InlineEmphasis(text: [
                                    .text(InlineString(text: "bar", range: (0,7)-(0,9)))
                                ],
                                range:(0, 6)-(0, 10))),
                                .text(InlineString(text: " baz", range: (0,11)-(0,14)))
                            ],
                            range:(0, 0)-(0, 16)))
                        ],
                        range: (0, 0)-(0, 17)))
                       ]))
    }
    
    func testCase424() throws {
        // HTML: <p><strong>foo <strong>bar</strong> baz</strong></p>\n
        /* Markdown
         __foo __bar__ baz__
         
         */
        XCTAssertEqual(try compile("__foo __bar__ baz__\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .strong(InlineStrong(text: [
                                .text(InlineString(text: "foo ", range: (0,2)-(0,5))),
                                .strong(InlineStrong(text: [
                                    .text(InlineString(text: "bar", range: (0,8)-(0,10)))
                                ],
                                range:(0, 6)-(0, 12))),
                                .text(InlineString(text: " baz", range: (0,13)-(0,16)))
                            ],
                            range:(0, 0)-(0, 18)))
                        ],
                        range: (0, 0)-(0, 19)))
                       ]))
    }
    
    func testCase425() throws {
        // HTML: <p><strong><strong>foo</strong> bar</strong></p>\n
        /* Markdown
         ____foo__ bar__
         
         */
        XCTAssertEqual(try compile("____foo__ bar__\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .strong(InlineStrong(text: [
                                .strong(InlineStrong(text: [
                                    .text(InlineString(text: "foo", range: (0,4)-(0,6)))
                                ],
                                range:(0, 2)-(0, 8))),
                                .text(InlineString(text: " bar", range: (0,9)-(0,12)))
                            ],
                            range:(0, 0)-(0, 14)))
                        ],
                        range: (0, 0)-(0, 15)))
                       ]))
    }
    
    func testCase426() throws {
        // HTML: <p><strong>foo <strong>bar</strong></strong></p>\n
        /* Markdown
         **foo **bar****
         
         */
        XCTAssertEqual(try compile("**foo **bar****\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .strong(InlineStrong(text: [
                                .text(InlineString(text: "foo ", range: (0,2)-(0,5))),
                                .strong(InlineStrong(text: [
                                    .text(InlineString(text: "bar", range: (0,8)-(0,10)))
                                ],
                                range:(0, 6)-(0, 12)))
                            ],
                            range:(0, 0)-(0, 14)))
                        ],
                        range: (0, 0)-(0, 15)))
                       ]))
    }
    
    func testCase427() throws {
        // HTML: <p><strong>foo <em>bar</em> baz</strong></p>\n
        /* Markdown
         **foo *bar* baz**
         
         */
        XCTAssertEqual(try compile("**foo *bar* baz**\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .strong(InlineStrong(text: [
                                .text(InlineString(text: "foo ", range: (0,2)-(0,5))),
                                .emphasis(InlineEmphasis(text: [
                                    .text(InlineString(text: "bar", range: (0,7)-(0,9)))
                                ],
                                range:(0, 6)-(0, 10))),
                                .text(InlineString(text: " baz", range: (0,11)-(0,14)))
                            ],
                            range:(0, 0)-(0, 16)))
                        ],
                        range: (0, 0)-(0, 17)))
                       ]))
    }
    
    func testCase428() throws {
        // HTML: <p><strong>foo<em>bar</em>baz</strong></p>\n
        /* Markdown
         **foo*bar*baz**
         
         */
        XCTAssertEqual(try compile("**foo*bar*baz**\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .strong(InlineStrong(text: [
                                .text(InlineString(text: "foo", range: (0,2)-(0,4))),
                                .emphasis(InlineEmphasis(text: [
                                    .text(InlineString(text: "bar", range: (0,6)-(0,8)))
                                ],
                                range:(0, 5)-(0, 9))),
                                .text(InlineString(text: "baz", range: (0,10)-(0,12)))
                            ],
                            range:(0, 0)-(0, 14)))
                        ],
                        range: (0, 0)-(0, 15)))
                       ]))
    }
    
    func testCase429() throws {
        // HTML: <p><strong><em>foo</em> bar</strong></p>\n
        /* Markdown
         ***foo* bar**
         
         */
        XCTAssertEqual(try compile("***foo* bar**\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .strong(InlineStrong(text: [
                                .emphasis(InlineEmphasis(text: [
                                    .text(InlineString(text: "foo", range: (0,3)-(0,5)))
                                ],
                                range:(0, 2)-(0, 6))),
                                .text(InlineString(text: " bar", range: (0,7)-(0,10)))
                            ],
                            range:(0, 0)-(0, 12)))
                        ],
                        range: (0, 0)-(0, 13)))
                       ]))
    }
    
    func testCase430() throws {
        // HTML: <p><strong>foo <em>bar</em></strong></p>\n
        /* Markdown
         **foo *bar***
         
         */
        XCTAssertEqual(try compile("**foo *bar***\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .strong(InlineStrong(text: [
                                .text(InlineString(text: "foo ", range: (0,2)-(0,5))),
                                .emphasis(InlineEmphasis(text: [
                                    .text(InlineString(text: "bar", range: (0,7)-(0,9)))
                                ],
                                range:(0, 6)-(0, 10)))
                            ],
                            range:(0, 0)-(0, 12)))
                        ],
                        range: (0, 0)-(0, 13)))
                       ]))
    }
    
    func testCase431() throws {
        // HTML: <p><strong>foo <em>bar <strong>baz</strong>\nbim</em> bop</strong></p>\n
        /* Markdown
         **foo *bar **baz**
         bim* bop**
         
         */
        XCTAssertEqual(try compile("**foo *bar **baz**\nbim* bop**\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .strong(InlineStrong(text: [
                                .text(InlineString(text: "foo ", range: (0,2)-(0,5))),
                                .emphasis(InlineEmphasis(text: [
                                    .text(InlineString(text: "bar ", range: (0,7)-(0,10))),
                                    .strong(InlineStrong(text: [
                                        .text(InlineString(text: "baz", range: (0,13)-(0,15)))
                                    ],
                                    range:(0, 11)-(0, 17))),
                                    .softbreak(InlineSoftbreak(range: (0, 18)-(0, 18))),
                                    .text(InlineString(text: "bim", range: (1,0)-(1,2)))
                                ],
                                range:(0, 6)-(1, 3))),
                                .text(InlineString(text: " bop", range: (1,4)-(1,7)))
                            ],
                            range:(0, 0)-(1, 9)))
                        ],
                        range: (0, 0)-(1, 10)))
                       ]))
    }
    
    func testCase432() throws {
        // HTML: <p><strong>foo <a href=\"/url\"><em>bar</em></a></strong></p>\n
        /* Markdown
         **foo [*bar*](/url)**
         
         */
        XCTAssertEqual(try compile("**foo [*bar*](/url)**\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .strong(InlineStrong(text: [
                                .text(InlineString(text: "foo ", range: (0,2)-(0,5))),
                                .link(InlineLink(link: Link(title: nil,
                                                            url: InlineString(text: "/url", range: (0, 14)-(0, 17))),
                                                 text: [
                                                    .emphasis(InlineEmphasis(text: [
                                                        .text(InlineString(text: "bar", range: (0,8)-(0,10)))
                                                    ],
                                                    range:(0, 7)-(0, 11)))
                                                 ],
                                                 range: (0, 6)-(0, 18)))
                            ],
                            range:(0, 0)-(0, 20)))
                        ],
                        range: (0, 0)-(0, 21)))
                       ]))
    }
    
    func testCase433() throws {
        // HTML: <p>__ is not an empty emphasis</p>\n
        /* Markdown
         __ is not an empty emphasis
         
         */
        XCTAssertEqual(try compile("__ is not an empty emphasis\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "__ is not an empty emphasis", range: (0,0)-(0,26)))
                        ],
                        range: (0, 0)-(0, 27)))
                       ]))
    }
    
    func testCase434() throws {
        // HTML: <p>____ is not an empty strong emphasis</p>\n
        /* Markdown
         ____ is not an empty strong emphasis
         
         */
        XCTAssertEqual(try compile("____ is not an empty strong emphasis\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "____ is not an empty strong emphasis", range: (0,0)-(0,35)))
                        ],
                        range: (0, 0)-(0, 36)))
                       ]))
    }
    
    func testCase435() throws {
        // HTML: <p>foo ***</p>\n
        /* Markdown
         foo ***
         
         */
        XCTAssertEqual(try compile("foo ***\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "foo ***", range: (0,0)-(0,6)))
                        ],
                        range: (0, 0)-(0, 7)))
                       ]))
    }
    
    func testCase436() throws {
        // HTML: <p>foo <em>*</em></p>\n
        /* Markdown
         foo *\**
         
         */
        XCTAssertEqual(try compile("foo *\\**\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "foo ", range: (0,0)-(0,3))),
                            .emphasis(InlineEmphasis(text: [
                                .text(InlineString(text: "*", range: (0,5)-(0,6)))
                            ],
                            range:(0, 4)-(0, 7)))
                        ],
                        range: (0, 0)-(0, 8)))
                       ]))
    }
    
    func testCase437() throws {
        // HTML: <p>foo <em>_</em></p>\n
        /* Markdown
         foo *_*
         
         */
        XCTAssertEqual(try compile("foo *_*\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "foo ", range: (0,0)-(0,3))),
                            .emphasis(InlineEmphasis(text: [
                                .text(InlineString(text: "_", range: (0,5)-(0,5)))
                            ],
                            range:(0, 4)-(0, 6)))
                        ],
                        range: (0, 0)-(0, 7)))
                       ]))
    }
    
    func testCase438() throws {
        // HTML: <p>foo *****</p>\n
        /* Markdown
         foo *****
         
         */
        XCTAssertEqual(try compile("foo *****\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "foo *****", range: (0,0)-(0,8)))
                        ],
                        range: (0, 0)-(0, 9)))
                       ]))
    }
    
    func testCase439() throws {
        // HTML: <p>foo <strong>*</strong></p>\n
        /* Markdown
         foo **\***
         
         */
        XCTAssertEqual(try compile("foo **\\***\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "foo ", range: (0,0)-(0,3))),
                            .strong(InlineStrong(text: [
                                .text(InlineString(text: "*", range: (0,6)-(0,7)))
                            ],
                            range:(0, 4)-(0, 9)))
                        ],
                        range: (0, 0)-(0, 10)))
                       ]))
    }
    
    func testCase440() throws {
        // HTML: <p>foo <strong>_</strong></p>\n
        /* Markdown
         foo **_**
         
         */
        XCTAssertEqual(try compile("foo **_**\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "foo ", range: (0,0)-(0,3))),
                            .strong(InlineStrong(text: [
                                .text(InlineString(text: "_", range: (0,6)-(0,6)))
                            ],
                            range:(0, 4)-(0, 8)))
                        ],
                        range: (0, 0)-(0, 9)))
                       ]))
    }
    
    func testCase441() throws {
        // HTML: <p>*<em>foo</em></p>\n
        /* Markdown
         **foo*
         
         */
        XCTAssertEqual(try compile("**foo*\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "*", range: (0,0)-(0,0))),
                            .emphasis(InlineEmphasis(text: [
                                .text(InlineString(text: "foo", range: (0,2)-(0,4)))
                            ],
                            range:(0, 1)-(0, 5)))
                        ],
                        range: (0, 0)-(0, 6)))
                       ]))
    }
    
    func testCase442() throws {
        // HTML: <p><em>foo</em>*</p>\n
        /* Markdown
         *foo**
         
         */
        XCTAssertEqual(try compile("*foo**\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .emphasis(InlineEmphasis(text: [
                                .text(InlineString(text: "foo", range: (0,1)-(0,3)))
                            ],
                            range:(0, 0)-(0, 4))),
                            .text(InlineString(text: "*", range: (0,5)-(0,5)))
                        ],
                        range: (0, 0)-(0, 6)))
                       ]))
    }
    
    func testCase443() throws {
        // HTML: <p>*<strong>foo</strong></p>\n
        /* Markdown
         ***foo**
         
         */
        XCTAssertEqual(try compile("***foo**\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "*", range: (0,0)-(0,0))),
                            .strong(InlineStrong(text: [
                                .text(InlineString(text: "foo", range: (0,3)-(0,5)))
                            ],
                            range:(0, 1)-(0, 7)))
                        ],
                        range: (0, 0)-(0, 8)))
                       ]))
    }
    
    func testCase444() throws {
        // HTML: <p>***<em>foo</em></p>\n
        /* Markdown
         ****foo*
         
         */
        XCTAssertEqual(try compile("****foo*\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "***", range: (0,0)-(0,2))),
                            .emphasis(InlineEmphasis(text: [
                                .text(InlineString(text: "foo", range: (0,4)-(0,6)))
                            ],
                            range:(0, 3)-(0, 7)))
                        ],
                        range: (0, 0)-(0, 8)))
                       ]))
    }
    
    func testCase445() throws {
        // HTML: <p><strong>foo</strong>*</p>\n
        /* Markdown
         **foo***
         
         */
        XCTAssertEqual(try compile("**foo***\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .strong(InlineStrong(text: [
                                .text(InlineString(text: "foo", range: (0,2)-(0,4)))
                            ],
                            range:(0, 0)-(0, 6))),
                            .text(InlineString(text: "*", range: (0,7)-(0,7)))
                        ],
                        range: (0, 0)-(0, 8)))
                       ]))
    }
    
    func testCase446() throws {
        // HTML: <p><em>foo</em>***</p>\n
        /* Markdown
         *foo****
         
         */
        XCTAssertEqual(try compile("*foo****\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .emphasis(InlineEmphasis(text: [
                                .text(InlineString(text: "foo", range: (0,1)-(0,3)))
                            ],
                            range:(0, 0)-(0, 4))),
                            .text(InlineString(text: "***", range: (0,5)-(0,7)))
                        ],
                        range: (0, 0)-(0, 8)))
                       ]))
    }
    
    func testCase447() throws {
        // HTML: <p>foo ___</p>\n
        /* Markdown
         foo ___
         
         */
        XCTAssertEqual(try compile("foo ___\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "foo ___", range: (0,0)-(0,6)))
                        ],
                        range: (0, 0)-(0, 7)))
                       ]))
    }
    
    func testCase448() throws {
        // HTML: <p>foo <em>_</em></p>\n
        /* Markdown
         foo _\__
         
         */
        XCTAssertEqual(try compile("foo _\\__\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "foo ", range: (0,0)-(0,3))),
                            .emphasis(InlineEmphasis(text: [
                                .text(InlineString(text: "_", range: (0,5)-(0,6)))
                            ],
                            range:(0, 4)-(0, 7)))
                        ],
                        range: (0, 0)-(0, 8)))
                       ]))
    }
    
    func testCase449() throws {
        // HTML: <p>foo <em>*</em></p>\n
        /* Markdown
         foo _*_
         
         */
        XCTAssertEqual(try compile("foo _*_\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "foo ", range: (0,0)-(0,3))),
                            .emphasis(InlineEmphasis(text: [
                                .text(InlineString(text: "*", range: (0,5)-(0,5)))
                            ],
                            range:(0, 4)-(0, 6)))
                        ],
                        range: (0, 0)-(0, 7)))
                       ]))
    }
    
    func testCase450() throws {
        // HTML: <p>foo _____</p>\n
        /* Markdown
         foo _____
         
         */
        XCTAssertEqual(try compile("foo _____\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "foo _____", range: (0,0)-(0,8)))
                        ],
                        range: (0, 0)-(0, 9)))
                       ]))
    }
    
    func testCase451() throws {
        // HTML: <p>foo <strong>_</strong></p>\n
        /* Markdown
         foo __\___
         
         */
        XCTAssertEqual(try compile("foo __\\___\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "foo ", range: (0,0)-(0,3))),
                            .strong(InlineStrong(text: [
                                .text(InlineString(text: "_", range: (0,6)-(0,7)))
                            ],
                            range:(0, 4)-(0, 9)))
                        ],
                        range: (0, 0)-(0, 10)))
                       ]))
    }
    
    func testCase452() throws {
        // HTML: <p>foo <strong>*</strong></p>\n
        /* Markdown
         foo __*__
         
         */
        XCTAssertEqual(try compile("foo __*__\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "foo ", range: (0,0)-(0,3))),
                            .strong(InlineStrong(text: [
                                .text(InlineString(text: "*", range: (0,6)-(0,6)))
                            ],
                            range:(0, 4)-(0, 8)))
                        ],
                        range: (0, 0)-(0, 9)))
                       ]))
    }
    
    func testCase453() throws {
        // HTML: <p>_<em>foo</em></p>\n
        /* Markdown
         __foo_
         
         */
        XCTAssertEqual(try compile("__foo_\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "_", range: (0,0)-(0,0))),
                            .emphasis(InlineEmphasis(text: [
                                .text(InlineString(text: "foo", range: (0,2)-(0,4)))
                            ],
                            range:(0, 1)-(0, 5)))
                        ],
                        range: (0, 0)-(0, 6)))
                       ]))
    }
    
    func testCase454() throws {
        // HTML: <p><em>foo</em>_</p>\n
        /* Markdown
         _foo__
         
         */
        XCTAssertEqual(try compile("_foo__\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .emphasis(InlineEmphasis(text: [
                                .text(InlineString(text: "foo", range: (0,1)-(0,3)))
                            ],
                            range:(0, 0)-(0, 4))),
                            .text(InlineString(text: "_", range: (0,5)-(0,5)))
                        ],
                        range: (0, 0)-(0, 6)))
                       ]))
    }
    
    func testCase455() throws {
        // HTML: <p>_<strong>foo</strong></p>\n
        /* Markdown
         ___foo__
         
         */
        XCTAssertEqual(try compile("___foo__\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "_", range: (0,0)-(0,0))),
                            .strong(InlineStrong(text: [
                                .text(InlineString(text: "foo", range: (0,3)-(0,5)))
                            ],
                            range:(0, 1)-(0, 7)))
                        ],
                        range: (0, 0)-(0, 8)))
                       ]))
    }
    
    func testCase456() throws {
        // HTML: <p>___<em>foo</em></p>\n
        /* Markdown
         ____foo_
         
         */
        XCTAssertEqual(try compile("____foo_\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "___", range: (0,0)-(0,2))),
                            .emphasis(InlineEmphasis(text: [
                                .text(InlineString(text: "foo", range: (0,4)-(0,6)))
                            ],
                            range:(0, 3)-(0, 7)))
                        ],
                        range: (0, 0)-(0, 8)))
                       ]))
    }
    
    func testCase457() throws {
        // HTML: <p><strong>foo</strong>_</p>\n
        /* Markdown
         __foo___
         
         */
        XCTAssertEqual(try compile("__foo___\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .strong(InlineStrong(text: [
                                .text(InlineString(text: "foo", range: (0,2)-(0,4)))
                            ],
                            range:(0, 0)-(0, 6))),
                            .text(InlineString(text: "_", range: (0,7)-(0,7)))
                        ],
                        range: (0, 0)-(0, 8)))
                       ]))
    }
    
    func testCase458() throws {
        // HTML: <p><em>foo</em>___</p>\n
        /* Markdown
         _foo____
         
         */
        XCTAssertEqual(try compile("_foo____\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .emphasis(InlineEmphasis(text: [
                                .text(InlineString(text: "foo", range: (0,1)-(0,3)))
                            ],
                            range:(0, 0)-(0, 4))),
                            .text(InlineString(text: "___", range: (0,5)-(0,7)))
                        ],
                        range: (0, 0)-(0, 8)))
                       ]))
    }
    
    func testCase459() throws {
        // HTML: <p><strong>foo</strong></p>\n
        /* Markdown
         **foo**
         
         */
        XCTAssertEqual(try compile("**foo**\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .strong(InlineStrong(text: [
                                .text(InlineString(text: "foo", range: (0,2)-(0,4)))
                            ],
                            range:(0, 0)-(0, 6)))
                        ],
                        range: (0, 0)-(0, 7)))
                       ]))
    }
    
    func testCase460() throws {
        // HTML: <p><em><em>foo</em></em></p>\n
        /* Markdown
         *_foo_*
         
         */
        XCTAssertEqual(try compile("*_foo_*\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .emphasis(InlineEmphasis(text: [
                                .emphasis(InlineEmphasis(text: [
                                    .text(InlineString(text: "foo", range: (0,2)-(0,4)))
                                ],
                                range:(0, 1)-(0, 5)))
                            ],
                            range:(0, 0)-(0, 6)))
                        ],
                        range: (0, 0)-(0, 7)))
                       ]))
    }
    
    func testCase461() throws {
        // HTML: <p><strong>foo</strong></p>\n
        /* Markdown
         __foo__
         
         */
        XCTAssertEqual(try compile("__foo__\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .strong(InlineStrong(text: [
                                .text(InlineString(text: "foo", range: (0,2)-(0,4)))
                            ],
                            range:(0, 0)-(0, 6)))
                        ],
                        range: (0, 0)-(0, 7)))
                       ]))
    }
    
    func testCase462() throws {
        // HTML: <p><em><em>foo</em></em></p>\n
        /* Markdown
         _*foo*_
         
         */
        XCTAssertEqual(try compile("_*foo*_\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .emphasis(InlineEmphasis(text: [
                                .emphasis(InlineEmphasis(text: [
                                    .text(InlineString(text: "foo", range: (0,2)-(0,4)))
                                ],
                                range:(0, 1)-(0, 5)))
                            ],
                            range:(0, 0)-(0, 6)))
                        ],
                        range: (0, 0)-(0, 7)))
                       ]))
    }
    
    func testCase463() throws {
        // HTML: <p><strong><strong>foo</strong></strong></p>\n
        /* Markdown
         ****foo****
         
         */
        XCTAssertEqual(try compile("****foo****\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .strong(InlineStrong(text: [
                                .strong(InlineStrong(text: [
                                    .text(InlineString(text: "foo", range: (0,4)-(0,6)))
                                ],
                                range:(0, 2)-(0, 8)))
                            ],
                            range:(0, 0)-(0, 10)))
                        ],
                        range: (0, 0)-(0, 11)))
                       ]))
    }
    
    func testCase464() throws {
        // HTML: <p><strong><strong>foo</strong></strong></p>\n
        /* Markdown
         ____foo____
         
         */
        XCTAssertEqual(try compile("____foo____\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .strong(InlineStrong(text: [
                                .strong(InlineStrong(text: [
                                    .text(InlineString(text: "foo", range: (0,4)-(0,6)))
                                ],
                                range:(0, 2)-(0, 8)))
                            ],
                            range:(0, 0)-(0, 10)))
                        ],
                        range: (0, 0)-(0, 11)))
                       ]))
    }
    
    func testCase465() throws {
        // HTML: <p><strong><strong><strong>foo</strong></strong></strong></p>\n
        /* Markdown
         ******foo******
         
         */
        XCTAssertEqual(try compile("******foo******\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .strong(InlineStrong(text: [
                                .strong(InlineStrong(text: [
                                    .strong(InlineStrong(text: [
                                        .text(InlineString(text: "foo", range: (0,6)-(0,8)))
                                    ],
                                    range:(0, 4)-(0, 10)))
                                ],
                                range:(0, 2)-(0, 12)))
                            ],
                            range:(0, 0)-(0, 14)))
                        ],
                        range: (0, 0)-(0, 15)))
                       ]))
    }
    
    func testCase466() throws {
        // HTML: <p><em><strong>foo</strong></em></p>\n
        /* Markdown
         ***foo***
         
         */
        XCTAssertEqual(try compile("***foo***\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .emphasis(InlineEmphasis(text: [
                                .strong(InlineStrong(text: [
                                    .text(InlineString(text: "foo", range: (0,3)-(0,5)))
                                ],
                                range:(0, 1)-(0, 7)))
                            ],
                            range:(0, 0)-(0, 8)))
                        ],
                        range: (0, 0)-(0, 9)))
                       ]))
    }
    
    func testCase467() throws {
        // HTML: <p><em><strong><strong>foo</strong></strong></em></p>\n
        /* Markdown
         _____foo_____
         
         */
        XCTAssertEqual(try compile("_____foo_____\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .emphasis(InlineEmphasis(text: [
                                .strong(InlineStrong(text: [
                                    .strong(InlineStrong(text: [
                                        .text(InlineString(text: "foo", range: (0,5)-(0,7)))
                                    ],
                                    range:(0, 3)-(0, 9)))
                                ],
                                range:(0, 1)-(0, 11)))
                            ],
                            range:(0, 0)-(0, 12)))
                        ],
                        range: (0, 0)-(0, 13)))
                       ]))
    }
    
    func testCase468() throws {
        // HTML: <p><em>foo _bar</em> baz_</p>\n
        /* Markdown
         *foo _bar* baz_
         
         */
        XCTAssertEqual(try compile("*foo _bar* baz_\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .emphasis(InlineEmphasis(text: [
                                .text(InlineString(text: "foo _bar", range: (0,1)-(0,8)))
                            ],
                            range:(0, 0)-(0, 9))),
                            .text(InlineString(text: " baz_", range: (0,10)-(0,14)))
                        ],
                        range: (0, 0)-(0, 15)))
                       ]))
    }
    
    func testCase469() throws {
        // HTML: <p><em>foo <strong>bar *baz bim</strong> bam</em></p>\n
        /* Markdown
         *foo __bar *baz bim__ bam*
         
         */
        XCTAssertEqual(try compile("*foo __bar *baz bim__ bam*\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .emphasis(InlineEmphasis(text: [
                                .text(InlineString(text: "foo ", range: (0,1)-(0,4))),
                                .strong(InlineStrong(text: [
                                    .text(InlineString(text: "bar *baz bim", range: (0,7)-(0,18)))
                                ],
                                range:(0, 5)-(0, 20))),
                                .text(InlineString(text: " bam", range: (0,21)-(0,24)))
                            ],
                            range:(0, 0)-(0, 25)))
                        ],
                        range: (0, 0)-(0, 26)))
                       ]))
    }
    
    func testCase470() throws {
        // HTML: <p>**foo <strong>bar baz</strong></p>\n
        /* Markdown
         **foo **bar baz**
         
         */
        XCTAssertEqual(try compile("**foo **bar baz**\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "**foo ", range: (0,0)-(0,5))),
                            .strong(InlineStrong(text: [
                                .text(InlineString(text: "bar baz", range: (0,8)-(0,14)))
                            ],
                            range:(0, 6)-(0, 16)))
                        ],
                        range: (0, 0)-(0, 17)))
                       ]))
    }
    
    func testCase471() throws {
        // HTML: <p>*foo <em>bar baz</em></p>\n
        /* Markdown
         *foo *bar baz*
         
         */
        XCTAssertEqual(try compile("*foo *bar baz*\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "*foo ", range: (0,0)-(0,4))),
                            .emphasis(InlineEmphasis(text: [
                                .text(InlineString(text: "bar baz", range: (0,6)-(0,12)))
                            ],
                            range:(0, 5)-(0, 13)))
                        ],
                        range: (0, 0)-(0, 14)))
                       ]))
    }
    
    func testCase472() throws {
        // HTML: <p>*<a href=\"/url\">bar*</a></p>\n
        /* Markdown
         *[bar*](/url)
         
         */
        XCTAssertEqual(try compile("*[bar*](/url)\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "*", range: (0,0)-(0,0))),
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "/url", range: (0, 8)-(0, 11))),
                                             text: [
                                                .text(InlineString(text: "bar*", range: (0,2)-(0,5)))
                                             ],
                                             range: (0, 1)-(0, 12)))
                        ],
                        range: (0, 0)-(0, 13)))
                       ]))
    }
    
    func testCase473() throws {
        // HTML: <p>_foo <a href=\"/url\">bar_</a></p>\n
        /* Markdown
         _foo [bar_](/url)
         
         */
        XCTAssertEqual(try compile("_foo [bar_](/url)\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "_foo ", range: (0,0)-(0,4))),
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "/url", range: (0, 12)-(0, 15))),
                                             text: [
                                                .text(InlineString(text: "bar_", range: (0,6)-(0,9)))
                                             ],
                                             range: (0, 5)-(0, 16)))
                        ],
                        range: (0, 0)-(0, 17)))
                       ]))
    }
    
    func testCase474() throws {
        // Input: *<img src=\"foo\" title=\"*\"/>\n
        // HTML: <p>*<img src=\"foo\" title=\"*\"/></p>\n
        XCTAssertEqual(try compile("*<img src=\"foo\" title=\"*\"/>\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "*<img src=”foo\" title=”*”/>", range: (0,0)-(0,26)))
                        ],
                        range: (0,0)-(0,27)))
                       ]))
    }
    
    func testCase475() throws {
        // Input: **<a href=\"**\">\n
        // HTML: <p>**<a href=\"**\"></p>\n
        XCTAssertEqual(try compile("**<a href=\"**\">\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "**<a href=”**\">", range: (0,0)-(0,14)))
                        ],
                        range: (0,0)-(0,15)))
                       ]))
    }
    
    func testCase476() throws {
        // Input: __<a href=\"__\">\n
        // HTML: <p>__<a href=\"__\"></p>\n
        XCTAssertEqual(try compile("__<a href=\"__\">\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "__<a href=”__\">", range: (0,0)-(0,14)))
                        ],
                        range: (0,0)-(0,15)))
                       ]))
    }
    
    func testCase477() throws {
        // HTML: <p><em>a <code>*</code></em></p>\n
        /* Markdown
         *a `*`*
         
         */
        XCTAssertEqual(try compile("*a `*`*\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .emphasis(InlineEmphasis(text: [
                                .text(InlineString(text: "a ", range: (0,1)-(0,2))),
                                .code(InlineCode(code: InlineString(text: "*", range: (0, 4)-(0, 4)),
                                                 range: (0, 3)-(0, 5)))
                            ],
                            range:(0, 0)-(0, 6)))
                        ],
                        range: (0, 0)-(0, 7)))
                       ]))
    }
    
    func testCase478() throws {
        // HTML: <p><em>a <code>_</code></em></p>\n
        /* Markdown
         _a `_`_
         
         */
        XCTAssertEqual(try compile("_a `_`_\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .emphasis(InlineEmphasis(text: [
                                .text(InlineString(text: "a ", range: (0,1)-(0,2))),
                                .code(InlineCode(code: InlineString(text: "_", range: (0, 4)-(0, 4)),
                                                 range: (0, 3)-(0, 5)))
                            ],
                            range:(0, 0)-(0, 6)))
                        ],
                        range: (0, 0)-(0, 7)))
                       ]))
    }
    
    func testCase479() throws {
        // HTML: <p>**a<a href=\"http://foo.bar/?q=**\">http://foo.bar/?q=**</a></p>\n
        /* Markdown
         **a<http://foo.bar/?q=**>
         
         */
        XCTAssertEqual(try compile("**a<http://foo.bar/?q=**>\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "**a", range: (0,0)-(0,2))),
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "http://foo.bar/?q=**", range: (0, 4)-(0, 23))),
                                             text: [
                                                .text(InlineString(text: "http://foo.bar/?q=**", range: (0,4)-(0,23)))
                                             ],
                                             range: (0, 3)-(0, 24)))
                        ],
                        range: (0, 0)-(0, 25)))
                       ]))
    }
    
    func testCase480() throws {
        // HTML: <p>__a<a href=\"http://foo.bar/?q=__\">http://foo.bar/?q=__</a></p>\n
        /* Markdown
         __a<http://foo.bar/?q=__>
         
         */
        XCTAssertEqual(try compile("__a<http://foo.bar/?q=__>\n"),
                       Document(elements: [
                        .paragraph(Paragraph(text: [
                            .text(InlineString(text: "__a", range: (0,0)-(0,2))),
                            .link(InlineLink(link: Link(title: nil,
                                                        url: InlineString(text: "http://foo.bar/?q=__", range: (0, 4)-(0, 23))),
                                             text: [
                                                .text(InlineString(text: "http://foo.bar/?q=__", range: (0,4)-(0,23)))
                                             ],
                                             range: (0, 3)-(0, 24)))
                        ],
                        range: (0, 0)-(0, 25)))
                       ]))
    }
    
    
}
