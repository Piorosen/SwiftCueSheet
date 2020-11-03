import XCTest

import CueSheetTests
import ParsingFailTests
import TimeTests
import TrackEditTests

public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ParsingFailTests.allTests),
        testCase(TimeTests.allTests),
        testCase(TrackEditTests.allTests),
        testCase(CueSheetTests.allTests)
    ]
}
//var tests = allTests()
XCTMain(allTests())
