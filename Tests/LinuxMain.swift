#if !os(watchOS)

import XCTest

import NativeMarkKitTests

var tests = [XCTestCaseEntry]()
tests += NativeMarkKitTests.allTests()
XCTMain(tests)

#endif
