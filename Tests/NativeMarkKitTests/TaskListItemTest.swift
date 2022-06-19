import Foundation
import XCTest
@testable import NativeMarkKit

final class TaskListItemTest: XCTestCase {
    func testCaseTaskList1() throws {
        XCTAssertEqual(try compile("- [ ] a\n- [x] b\n- [X] c\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(
                                    taskListItemMark: TaskListItemMark(
                                        text: "[ ]",
                                        contentText: " ",
                                        range: (0,2)-(0,4)),
                                    text: [
                                        .text(InlineString(text: "a", range: (0,6)-(0,6)))
                                    ],
                                    range: (0, 2)-(0, 7)))
                            ], range: (0, 0)-(0,7)),
                            ListItem(elements: [
                                .paragraph(Paragraph(
                                    taskListItemMark: TaskListItemMark(
                                        text: "[x]",
                                        contentText: "x",
                                        range: (1,2)-(1,4)),
                                    text: [
                                        .text(InlineString(text: "b", range: (1,6)-(1,6)))
                                    ],
                                    range: (1, 2)-(1, 7)))
                            ], range: (1, 0)-(1,7)),
                            ListItem(elements: [
                                .paragraph(Paragraph(
                                    taskListItemMark: TaskListItemMark(
                                        text: "[X]",
                                        contentText: "X",
                                        range: (2,2)-(2,4)),
                                    text: [
                                        .text(InlineString(text: "c", range: (2,6)-(2,6)))
                                    ],
                                    range: (2, 2)-(2,7)))
                            ], range: (2, 0)-(2,7))
                        ]))
                       ]))
    }
    
    func testCaseTaskList2() throws {
        XCTAssertEqual(try compile("- [ ]a\n- [O] b\n-   [X] c\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: true, kind: .bulleted), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(
                                    taskListItemMark: nil,
                                    text: [
                                        .text(InlineString(text: "[ ]a", range: (0,2)-(0,5)))
                                    ],
                                    range: (0, 2)-(0, 6)))
                            ], range: (0, 0)-(0,6)),
                            ListItem(elements: [
                                .paragraph(Paragraph(
                                    taskListItemMark: nil,
                                    text: [
                                        .text(InlineString(text: "[O] b", range: (1,2)-(1,6)))
                                    ],
                                    range: (1, 2)-(1, 7)))
                            ], range: (1, 0)-(1,7)),
                            ListItem(elements: [
                                .paragraph(Paragraph(
                                    taskListItemMark: TaskListItemMark(
                                        text: "[X]",
                                        contentText: "X",
                                        range: (2,4)-(2,6)),
                                    text: [
                                        .text(InlineString(text: "c", range: (2,8)-(2,8)))
                                    ],
                                    range: (2, 4)-(2,9)))
                            ], range: (2, 0)-(2,9))
                        ]))
                       ]))
    }

    func testCaseTaskList3() throws {
        XCTAssertEqual(try compile("1. [ ] a\n1. b\n1. c\n\n   [X] d\n"),
                       Document(elements: [
                        .list(List(info: ListInfo(isTight: false, kind: .ordered(start: 1)), items: [
                            ListItem(elements: [
                                .paragraph(Paragraph(
                                    taskListItemMark: TaskListItemMark(
                                        text: "[ ]",
                                        contentText: " ",
                                        range: (0,3)-(0,5)),
                                    text: [
                                        .text(InlineString(text: "a", range: (0,7)-(0,7)))
                                    ],
                                    range: (0, 3)-(0, 8)))
                            ], range: (0, 0)-(0,8)),
                            ListItem(elements: [
                                .paragraph(Paragraph(
                                    taskListItemMark: nil,
                                    text: [
                                        .text(InlineString(text: "b", range: (1,3)-(1,3)))
                                    ],
                                    range: (1, 3)-(1, 4)))
                            ], range: (1, 0)-(1,4)),
                            ListItem(elements: [
                                .paragraph(Paragraph(
                                    taskListItemMark: nil,
                                    text: [
                                        .text(InlineString(text: "c", range: (2,3)-(2,3)))
                                    ],
                                    range: (2, 3)-(2,4))),
                                .paragraph(Paragraph(
                                    taskListItemMark: nil,
                                    text: [
                                        .text(InlineString(text: "[X] d", range: (4,3)-(4,7)))
                                    ],
                                    range: (4, 3)-(4,8)))

                            ], range: (2, 0)-(4,8))
                        ]))
                       ]))
    }
}
